//
//  IAvatarGalleryService.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 25/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

protocol IAvatarGalleryService {
    func fetchPixabayImages(completionHandler: @escaping (PixabayModel?, String?) -> Void)
}
