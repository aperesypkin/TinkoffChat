//
//  Storage.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 25/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

class Storage {
    static let `default` = Storage()
    
    var people: [String: ConversationsListModel] = [:]
    var messages: [String: [ConversationModel]] = [:]
}
