//
//  PixabayParser.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 25/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

class PixabayParser: IParser {
    typealias Model = PixabayModel
    
    func parse(data: Data) -> Model? {
        do {
            let model = try JSONDecoder().decode(Model.self, from: data)
            return model
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
