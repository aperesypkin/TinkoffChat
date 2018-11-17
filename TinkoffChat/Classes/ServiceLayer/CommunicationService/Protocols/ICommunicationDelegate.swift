//
//  ICommunicationDelegate.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 17/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

protocol ICommunicationDelegate: class {
    func didLostUser(userID: String)
    func didFoundUser(userID: String)
}
