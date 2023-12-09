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
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var imageGrid: UICollectionView!
    
    @IBAction func searchTapped(_ sender: UIButton) {
        
    }
    
    private let imageSearcher: ImageSearcher = GiphyImageSearcher(step: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

}

