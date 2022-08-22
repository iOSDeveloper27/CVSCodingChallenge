//
//  FlickrImageCell.swift
//  CVSCodingChallenge
//
//  Created by Brandon Riehle on 8/18/22.
//

import UIKit

class FlickrImageCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    var imageUrl: URL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @MainActor private func showImage(image: UIImage, urlImage: URL?=nil) {
        //after image download make sure its the original url
        if imageUrl == urlImage {
            imageView.image = image
        }
    }
    
    func configure(with flickrImage: FlickrImage) {
        
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 3
        layer.cornerRadius = 7
        
        titleLabel.text = flickrImage.title
        self.showImage(image: UIImage(named: "defaultImage")!)
        
        if let url = URL(string: flickrImage.image) {
            imageUrl = url
            
            Task {
                do {
                    let image = try await Networking.downloadImage(from:url)
                    self.showImage(image: image, urlImage: imageUrl)
                } catch let error {
                    print(error)
                }
            }
        }
    }
}
