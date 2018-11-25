//
//  ImageParser.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 25/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

class ImageParser: IParser {
    typealias Model = UIImage
    
    func parse(data: Data) -> Model? {
        return UIImage(data: data)
    }
}
