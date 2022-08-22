//
//  ImageCell.swift
//  CVSCodingChallenge
//
//  Created by Brandon Riehle on 8/19/22.
//

import UIKit

class ImageCell: UITableViewCell {

    @IBOutlet var flickrImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(with stringUrl: String) {
        self.setImage(UIImage(named: "defaultImage")!)
        
        if let url = URL(string: stringUrl) {
            Task {
                do {
                    let image = try await Networking.downloadImage(from:url)
                    setImage(image)
                } catch let error {
                    print(error)   
                }
            }
        }
    }
    
    @MainActor func setImage(_ image: UIImage) {
        flickrImageView.image = image
    }
}
