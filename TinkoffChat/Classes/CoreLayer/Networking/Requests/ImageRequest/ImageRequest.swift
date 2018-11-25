//
//  ImageRequest.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 25/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

class ImageRequest: IRequest {
    var urlRequest: URLRequest?
    
    init(url: URL) {
        urlRequest = URLRequest(url: url)
    }
}
