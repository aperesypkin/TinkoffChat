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
            fetchImage()
        }
    }
    
    func configure(with model: AvatarGalleryViewModel) {
        imageURL = model.imageURL
    }
    
    private func fetchImage() {
        guard let url = imageURL else { return }
        
        avatarImageView.image = #imageLiteral(resourceName: "placeholder-user")
        activityIndicator.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let urlContents = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                if let imageData = urlContents, url == self?.imageURL {
                    self?.avatarImageView.image = UIImage(data: imageData)
                }
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
}
