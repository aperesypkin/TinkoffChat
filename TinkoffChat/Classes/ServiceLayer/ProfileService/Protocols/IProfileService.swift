//
//  IProfileService.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 17/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

protocol IProfileService {
    var delegate: IProfileServiceDelegate? { get set }
    func save(name: String?, aboutMe: String?, imageData: NSData?)
    func load()
}
