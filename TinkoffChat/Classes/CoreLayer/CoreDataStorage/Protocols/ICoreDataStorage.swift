//
//  ICoreDataStorage.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 17/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

protocol ICoreDataStorage {
    func saveFoundedUser(userID: String, userName: String?)
    func saveLostUser(userID: String)
    func saveReceivedMessage(text: String, fromUser: String, isUnread: Bool)
    func saveSendMessage(text: String, for userID: String)
    func markMessagesAsRead(for user: String)
    func moveAllConversationsToHistory()
}
