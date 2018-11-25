//
//  AvatarGalleryDataManager.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 23/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

protocol IAvatarGalleryDataManager {
    func fetchImages(completionHandler: @escaping ([AvatarGalleryViewModel]?) -> Void)
    func fetchImage(url: URL, completionHandler: @escaping (UIImage?) -> Void)
}

struct AvatarGalleryViewModel {
    let imageURL: URL
}

class AvatarGalleryDataManager: IAvatarGalleryDataManager {
        
    private let avatarGalleryService: IAvatarGalleryService
    
    private var cachedImages: [URL: UIImage] = [:]
    
    init(avatarGalleryService: IAvatarGalleryService) {
        self.avatarGalleryService = avatarGalleryService
    }
    
    func fetchImages(completionHandler: @escaping ([AvatarGalleryViewModel]?) -> Void) {
        avatarGalleryService.fetchPixabayImages { model, error in
            if let error = error {
                DispatchQueue.main.async {
                    print(error)
                    completionHandler(nil)
                    return
                }
            }
            
            if let model = model {
                let viewModels = model.images.map { AvatarGalleryViewModel(imageURL: $0.imageURL) }
                DispatchQueue.main.async {
                    completionHandler(viewModels)
                    return
                }
            }
        }
    }
    
    func fetchImage(url: URL, completionHandler: @escaping (UIImage?) -> Void) {
        if let image = cachedImages[url] {
            completionHandler(image)
            return
        }
        
        avatarGalleryService.fetchImage(url: url) { image, error in
            if let error = error {
                DispatchQueue.main.async {
                    print(error)
                    completionHandler(nil)
                    return
                }
            }
            
            if let image = image {
                DispatchQueue.main.async {
                    self.cachedImages[url] = image
                    completionHandler(image)
                }
            }
        }
    }
    
}
