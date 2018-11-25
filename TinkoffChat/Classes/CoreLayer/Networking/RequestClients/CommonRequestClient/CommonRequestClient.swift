//
//  CommonRequestClient.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 25/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

class CommonRequestClient: IRequestClient {
    
    func send<Parser>(config: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model>) -> Void) where Parser: IParser {
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(.error("url string can't be parsed to URL"))
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            if let error = error {
                completionHandler(.error(error.localizedDescription))
                return
            }
            
            guard let data = data, let parsedModel = config.parser.parse(data: data) else {
                completionHandler(.error("received data can't be parsed"))
                return
            }
            
            completionHandler(.success(parsedModel))
        }
        
        dataTask.resume()
    }
    
}
