//
//  ConversationModel.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 27/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

class ConversationModel {
    let message: String
    let date: Date
    let isIncomingMessage: Bool
    var isUnread: Bool
    
    init(message: String, date: Date, isIncomingMessage: Bool, isUnread: Bool) {
        self.message = message
        self.date = date
        self.isIncomingMessage = isIncomingMessage
        self.isUnread = isUnread
    }
}

extension ConversationModel {
    typealias ViewModel = ConversationViewController.ViewModel
    
    var viewModel: ViewModel {
        return ViewModel(text: message)
    }
    
    func markAsRead() {
        isUnread = false
    }
}
