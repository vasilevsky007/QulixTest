//
//  ImageCell.swift
//  QulixTest
//
//  Created by Alex on 9.12.23.
//

import UIKit

class ImageCell: UICollectionViewCell {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    
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
                if let animated = UIImage.animatedImage(withGIFData: imageData) {
                    imageView.image = animated
                } else {
                    imageView.image = UIImage(data: imageData)
                }
                imageView.isHidden = false
            case .failed(let error):
                spinner.stopAnimating()
                imageView.image = UIImage(systemName: "exclamationmark.triangle")?.withTintColor(.red)
            default: break
            }
        }
    }
    
    private func setStatus(_ status: ImageStatus) {
        imageStatus = status
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func setup(image: ImageData, fetcher: ImageFetcher?) {
        spinner.hidesWhenStopped = true
        guard let fetcher = fetcher else {
            imageStatus = .failed(error: QulixTestError.noImageFetcherToFetchImage)
            return
        }
        imageStatus = .loading
        Task.detached {
            do {
                let imageData = try await fetcher.imageData(forUrl: image.images.fixedHeight)
                await self.setStatus(.loaded(imageData: imageData))
            } catch {
                await self.setStatus(.failed(error: error))
            }
        }
    }

}
