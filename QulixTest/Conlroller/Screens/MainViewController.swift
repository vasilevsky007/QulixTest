//
//  MainViewController.swift
//  QulixTest
//
//  Created by Alex on 8.12.23.
//

import UIKit

class MainViewController: UIViewController {
    
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
            imageStore.removeAll()
            imageGrid.reloadData()
            Task.detached { [weak self] in
                let images = try await self!.imageSearcher.search(for: searchQ)
                self?.imageStore.add(images)
                await self?.imageGrid.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.imageGrid.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        self.imageGrid.dataSource = self
        self.imageGrid.delegate = self
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
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        openSheet(withProductIndex: indexPath.item)
//    }
    
}


