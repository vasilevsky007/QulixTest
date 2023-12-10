//
//  MainViewController.swift
//  QulixTest
//
//  Created by Alex on 8.12.23.
//

import UIKit

class MainViewController: UIViewController {
    private var loadingIndicator = UIActivityIndicatorView(style: .large
    )
    
    private let imageFetcher: ImageFetcher? = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = appDelegate.persistentContainer.viewContext
        let fetcher = ImageFetcher()
        Task {
            await fetcher.setContext(context: context)
        }
        return fetcher
    }()
    private let imageStore = ImageDataStore()
    private let imageSearcher: ImageSearcher = GiphyImageSearcher(step: 20)
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var imageGrid: UICollectionView!
    
    @IBAction func searchTapped(_ sender: UIButton) {
        if let searchQ = searchField.text, searchQ != "" {
            view.endEditing(true)
            imageStore.removeAll()
            imageGrid.reloadData()
            Task.detached { [weak self] in
                let images = try await self!.imageSearcher.search(for: searchQ)
                self?.imageStore.add(images)
                await self?.imageGrid.reloadData()
            }
        }
    }
    
    
    private weak var sheetPresented: ImageDetailsViewController?
    
    func openSheet(withImageIndex imageIndex: Int) {
        let viewControllerToPresent = ImageDetailsViewController()
        if #available(iOS 15.0, *) { //this is working 100% sure
            if let sheet = viewControllerToPresent.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.largestUndimmedDetentIdentifier = .medium
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.prefersEdgeAttachedInCompactHeight = false
                sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
                sheet.prefersGrabberVisible = true
            }
            
        } else {
            // Fallback on earlier versions
            viewControllerToPresent.modalPresentationStyle = .pageSheet //don't know if this will work as intended, lowest ios simulator version is 15 now in xcode.
        }
        if sheetPresented != nil {
            sheetPresented?.setup(image: imageStore.items[imageIndex], fetcher: imageFetcher)
        } else {
            present(viewControllerToPresent, animated: true, completion: nil)
            sheetPresented = viewControllerToPresent
            sheetPresented?.setup(image: imageStore.items[imageIndex], fetcher: imageFetcher)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.imageGrid.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        self.imageGrid.dataSource = self
        self.imageGrid.delegate = self
        loadingIndicator.hidesWhenStopped = true
        imageGrid.addSubview(loadingIndicator)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "OpenSettingsSegue" {
            if let settingsController = segue.destination as? SettingsViewController {
                settingsController.imageFetcher = self.imageFetcher
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard !loadingIndicator.isAnimating else { return }
            loadingIndicator.startAnimating()
            Task.detached { [weak self] in
                do {
                    let newImages = try await self!.imageSearcher.getNext()
                    self?.imageStore.add(newImages)
                    await self?.imageGrid.reloadData()
                    await self?.imageGrid.reloadData()
                    await self?.loadingIndicator.stopAnimating()
                } catch {
                    print("Error refreshing data: \(error)")
                    await self?.loadingIndicator.stopAnimating()
                }
            }
        }
    }
}

extension MainViewController: UICollectionViewDataSource ,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageStore.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: "ImageCell",
                for: indexPath) as! ImageCell
        cell.setup(image: imageStore.items[indexPath.item], fetcher: imageFetcher)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        let gridItemWidth = (screenWidth - 48) / 2.0
        return CGSize(width: gridItemWidth, height: gridItemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        openSheet(withImageIndex: indexPath.item)
    }
}


