//
//  MultipeerMessage.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 11/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

struct MultipeerMessage: Codable {
    let eventType: String
    let text: String
    let messageId: String
    
    var data: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init(eventType: String, text: String, messageId: String) {
        self.eventType = eventType
        self.text = text
        self.messageId = messageId
    }
    
    init?(data: Data) {
        if let newValue = try? JSONDecoder().decode(MultipeerMessage.self, from: data) {
            self = newValue
        } else {
            return nil
        }
    }
}
