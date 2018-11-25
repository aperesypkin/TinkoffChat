//
//  PixabayRequest.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 25/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

class PixabayRequest: IRequest {
    private let baseURL = "https://pixabay.com/api/"
    
    private let queryItems = [URLQueryItem(name: "key", value: "10789918-7f8155f145a170c1c4540dd17"),
                              URLQueryItem(name: "q", value: "yellow+flowers"),
                              URLQueryItem(name: "image_type", value: "photo"),
                              URLQueryItem(name: "per_page", value: "198")]
    
    var urlRequest: URLRequest? {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = queryItems
        
        if let url = urlComponents?.url {
            return URLRequest(url: url)
        } else {
            return nil
        }
    }
}
