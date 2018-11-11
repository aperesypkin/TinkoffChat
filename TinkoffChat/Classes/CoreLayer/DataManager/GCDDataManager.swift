//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 20/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

class GCDDataManager: DataManager {
    func save<T: Codable>(_ object: T, to fileName: String, completionHandler: @escaping (Error?) -> Void) {
        DispatchQueue.global().async {
            do {
                let url = self.createURL(withFileName: fileName)
                let data = try JSONEncoder().encode(object)
                try data.write(to: url, options: .atomic)
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
            }
        }
    }
    
    func load<T: Codable>(_ type: T.Type, from fileName: String, completionHandler: @escaping (T?, Error?) -> Void) {
        DispatchQueue.global().async {
            do {
                let url = self.createURL(withFileName: fileName)
                let data = try Data(contentsOf: url)
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(decodedData, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
        }

    }
}
