//
//  CommonAvatarGalleryService.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 25/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

class CommonAvatarGalleryService: IAvatarGalleryService {
    
    private let requestClient: IRequestClient
    
    init(requestClient: IRequestClient) {
        self.requestClient = requestClient
    }
    
    func fetchPixabayImages(completionHandler: @escaping (PixabayModel?, String?) -> Void) {
        requestClient.send(config: RequestsFactory.Pixabay.imageConfig()) { result in
            switch result {
            case .success(let model): completionHandler(model, nil)
            case .error(let error): completionHandler(nil, error)
            }
        }
    }
    
    func fetchImage(url: URL, completionHandler: @escaping (UIImage?, String?) -> Void) {
        requestClient.send(config: RequestsFactory.Common.image(for: url)) { result in
            switch result {
            case .success(let model): completionHandler(model, nil)
            case .error(let error): completionHandler(nil, error)
            }
        }
    }
    
}
