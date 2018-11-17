//
//  ICommunicationService.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 17/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

protocol ICommunicationService {
    var delegate: ICommunicationDelegate? { get set }
    func send(text: String, for userID: String)
    func markMessagesAsRead(for userID: String)
    func startComminucation()
}
