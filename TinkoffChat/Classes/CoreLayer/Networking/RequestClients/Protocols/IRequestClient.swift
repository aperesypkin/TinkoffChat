//
//  IRequestClient.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 25/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

struct RequestConfig<Parser: IParser> {
    let request: IRequest
    let parser: Parser
}

enum Result<Model> {
    case success(Model)
    case error(String)
}

protocol IRequestClient {
    func send<Parser>(config: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model>) -> Void)
}
