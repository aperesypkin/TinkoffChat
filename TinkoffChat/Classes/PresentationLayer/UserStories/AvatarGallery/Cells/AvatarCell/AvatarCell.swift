//
//  AvatarCell.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 25/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import UIKit

class AvatarCell: UICollectionViewCell {
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private var imageURL: URL? {
        didSet {
            avatarImageView.image = #imageLiteral(resourceName: "placeholder-user")
            fetchImage()
        }
    }
    
    private var cachedImages: [URL: UIImage?] = [:]
    
    func configure(with model: AvatarGalleryViewModel) {
        imageURL = model.imageURL
    }
    
    private func fetchImage() {
        if let url = imageURL {
            if let image = cachedImages[url] {
                avatarImageView.image = image
            } else {
                activityIndicator.startAnimating()
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    let urlContents = try? Data(contentsOf: url)
                    DispatchQueue.main.async {
                        if let imageData = urlContents, url == self?.imageURL {
                            let image = UIImage(data: imageData)
                            self?.cachedImages[url] = image
                            self?.avatarImageView.image = image
                            self?.activityIndicator.stopAnimating()
                        }
                    }
                }
            }
            
        }
    }
    
}
