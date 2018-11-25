//
//  PixabayModel.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 25/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

struct PixabayModel: Decodable {
    let images: [Image]
    
    struct Image: Decodable {
        let imageURL: URL
        
        private enum CodingKeys: String, CodingKey {
            case imageURL = "webformatURL"
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case images = "hits"
    }
    
}
