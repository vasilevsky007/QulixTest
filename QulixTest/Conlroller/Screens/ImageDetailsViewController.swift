//
//  ImageDetailsViewController.swift
//  QulixTest
//
//  Created by Alex on 10.12.23.
//

import UIKit

class ImageDetailsViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var imported: UILabel!
    @IBOutlet weak var lastUpdated: UILabel!
    @IBOutlet weak var created: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userDisplayName: UILabel!
    @IBOutlet weak var username: UILabel!
    
    @IBAction func tapClose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func tapShare(_ sender: UIButton) {
        
    }
    
    enum ImageStatus {
        case loading
        case loaded(imageData: Data)
        case failed(error: Error)
    }
    
    private var imageStatus: ImageStatus!{
        didSet {
            switch imageStatus {
            case .loading:
                imageView.isHidden = true
                spinner.startAnimating()
            case .loaded(let imageData):
                spinner.stopAnimating()
                imageView.image = UIImage(data: imageData)
                imageView.isHidden = false
            case .failed(let error):
                spinner.stopAnimating()
                imageView.image = UIImage(systemName: "exclamationmark.triangle")?.withTintColor(.red)
            default: break
            }
        }
    }
    
    private var userImageStatus: ImageStatus!{
        didSet {
            switch userImageStatus {
            case .loading:
                userImage.image = UIImage(systemName: "person.crop.circle")
            case .loaded(let imageData):
                userImage.image = UIImage(data: imageData)
            case .failed(let error):
                userImage.image = UIImage(systemName: "person.crop.circle")?.withTintColor(.red)
            default: break
            }
        }
    }
    
    private func setImageStatus(_ status: ImageStatus) {
        imageStatus = status
    }
    
    private func setUserImageStatus(_ status: ImageStatus) {
        userImageStatus = status
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setup(image: ImageData, fetcher: ImageFetcher?) {
        spinner.hidesWhenStopped = true
        //making avatar round
        userImage.layer.masksToBounds = false
        userImage.layer.borderColor = UIColor.black.cgColor
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.clipsToBounds = true
        
        guard let fetcher = fetcher else {
            imageStatus = .failed(error: QulixTestError.noImageFetcherToFetchImage)
            userImageStatus = .failed(error: QulixTestError.noImageFetcherToFetchImage)
            return
        }
        imageTitle.text = image.title
        if let importedString = image.imported?.description {
            imported.isHidden = false
            imported.text = "Imported: " + importedString
        } else {
            imported.isHidden = true
        }
        
        if let lastUpdatedString = image.lastUpdated?.description {
            lastUpdated.isHidden = false
            lastUpdated.text = "Updated: " +  lastUpdatedString
        } else {
            lastUpdated.isHidden = true
        }
        
        if let createdString = image.created?.description {
            created.isHidden = false
            created.text = "Created: " +  createdString
        } else {
            created.isHidden = true
        }
        setImageStatus(.loading)
        Task.detached {
            do {
                let imageData = try await fetcher.imageData(forUrl: image.images.original)
                await self.setImageStatus(.loaded(imageData: imageData))
            } catch {
                await self.setImageStatus(.failed(error: error))
            }
        }
        if let user = image.user {
            userImage.isHidden = false
            username.isHidden = false
            userDisplayName.isHidden = false
            setUserImageStatus(.loading)
            username.text = "@" + user.username
            userDisplayName.text = user.displayName
            Task.detached {
                do {
                    let imageData = try await fetcher.imageData(forUrl: user.avatar)
                    await self.setUserImageStatus(.loaded(imageData: imageData))
                } catch {
                    await self.setUserImageStatus(.failed(error: error))
                }
            }
        } else {
            userImage.isHidden = true
            username.isHidden = true
            userDisplayName.isHidden = true
        }
    }

}
