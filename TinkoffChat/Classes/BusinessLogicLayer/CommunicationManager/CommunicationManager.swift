//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 25/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation
import CoreData

protocol CommunicatorDelegate: class {
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
}

class CommunicationManager: CommunicatorDelegate {
    
    var currentUserStatus: ((Bool) -> Void)?
    
    var currentUserID: String?
    
    private let storage = CoreDataStorageManager()
    
    private var communicator: Communicator = MultipeerCommunicator()
    
    init() {
        communicator.delegate = self
    }
    
    func didOpenConversation(with user: String) {
        currentUserID = user
        storage.markMessagesAsRead(for: user)
    }
    
    func didCloseConversation() {
        currentUserID = nil
    }
    
    func send(text: String, for userID: String) {
        communicator.sendMessage(string: text, to: userID) { isSuccess, error in
            if isSuccess {
                self.storage.saveSendMessage(text: text, for: userID)
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        storage.saveReceivedMessage(text: text, fromUser: fromUser, toUser: toUser, isUnread: fromUser != currentUserID)
    }
    
    func didFoundUser(userID: String, userName: String?) {
        storage.saveFoundedUser(userID: userID, userName: userName)
        
        if userID == self.currentUserID {
            self.currentUserStatus?(true)
        }
    }
    
    func didLostUser(userID: String) {
        storage.saveLostUser(userID: userID)
        
        if userID == self.currentUserID {
            self.currentUserStatus?(false)
        }
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        print(error.localizedDescription)
    }
    
    func failedToStartAdvertising(error: Error) {
        print(error.localizedDescription)
    }
    
}
