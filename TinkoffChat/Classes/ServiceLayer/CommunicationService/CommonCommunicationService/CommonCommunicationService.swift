//
//  CommonCommunicationService.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 25/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

class CommonCommunicationService: ICommunicationService, ICommunicatorDelegate {
    
    weak var delegate: ICommunicationServiceDelegate?
    
    private let communicator: ICommunicator
    private let storage: ICoreDataStorage
    
    init(communicator: ICommunicator, storage: ICoreDataStorage) {
        self.communicator = communicator
        self.storage = storage
    }
    
    func startComminucation() {
        storage.moveAllConversationsToHistory()
        storage.createAppUserIfNeeded()
        communicator.start()
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
    
    func markMessagesAsRead(for userID: String) {
        storage.markMessagesAsRead(for: userID)
    }
    
    func didReceiveMessage(text: String, fromUser: String) {
        storage.saveReceivedMessage(text: text, fromUser: fromUser, isUnread: true)
    }
    
    func didFoundUser(userID: String, userName: String?) {
        delegate?.didFoundUser(userID: userID)
        storage.saveFoundedUser(userID: userID, userName: userName)
    }
    
    func didLostUser(userID: String) {
        delegate?.didLostUser(userID: userID)
        storage.saveLostUser(userID: userID)
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        print(error.localizedDescription)
    }
    
    func failedToStartAdvertising(error: Error) {
        print(error.localizedDescription)
    }
    
}
