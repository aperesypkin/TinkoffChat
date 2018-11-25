//
//  RequestsFactory.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 25/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

struct RequestsFactory {
    struct Pixabay {
        static func imageConfig() -> RequestConfig<PixabayParser> {
            return RequestConfig(request: PixabayRequest(), parser: PixabayParser())
        }
    }
    
    struct Common {
        static func image(for url: URL) -> RequestConfig<ImageParser> {
            return RequestConfig(request: ImageRequest(url: url), parser: ImageParser())
        }
    }
}
