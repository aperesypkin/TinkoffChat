//
//  DataManager.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 20/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

protocol DataManager {
    func save<T: Codable>(_ object: T, to fileName: String, completionHandler: @escaping (Error?) -> Void)
    func load<T: Codable>(_ type: T.Type, from fileName: String, completionHandler: @escaping (T?, Error?) -> Void)
}

extension DataManager {
    func createURL(withFileName fileName: String) -> URL {
        let fileManager = FileManager.default
        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return url.appendingPathComponent(fileName).appendingPathExtension("json")
    }
}
