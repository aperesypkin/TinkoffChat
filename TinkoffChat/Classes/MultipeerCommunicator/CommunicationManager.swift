//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 25/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

private extension String {
    static let queueIdentifier = "com.aperesypkin.tinkoffchat.communicationmanager"
}

class CommunicationManager: CommunicatorDelegate {
    
    var didChangeConversationsListAction: (([ConversationsListModel]) -> Void)?
    var didChangeMessagesAction: (([ConversationModel]) -> Void)?
    var currentUserStatus: ((Bool) -> Void)?
    
    var currentUserID: String?
    
    private var communicator: Communicator = MultipeerCommunicator()
    private let storage = Storage.default
    
    private lazy var backgroundQueue: DispatchQueue = {
        let queue = DispatchQueue(label: .queueIdentifier, qos: .userInitiated)
        return queue
    }()
    
    init() {
        communicator.delegate = self
    }
    
    func obtainMessages(for userID: String, completionHandler: @escaping ([ConversationModel]?) -> Void) {
        backgroundQueue.async {
            self.storage.people[userID]?.hasUnreadMessages = false
            let people = self.sortPeople(Array(self.storage.people.values))
            
            self.storage.messages[userID]?.forEach { $0.markAsRead() }
            
            DispatchQueue.main.async {
                self.didChangeConversationsListAction?(people)
                completionHandler(self.storage.messages[userID])
            }
        }
    }
    
    func send(message: String, for userID: String) {
        communicator.sendMessage(string: message, to: userID) { isSuccess, error in
            if isSuccess {
                self.backgroundQueue.async {
                    self.updateMessages(with: message, isIncoming: false, for: userID)
                    self.updateConversationsList(with: message, for: userID)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func didFoundUser(userID: String, userName: String?) {
        backgroundQueue.async {
            let conversationModel = self.storage.messages[userID]?.last
            let model = ConversationsListModel(userID: userID,
                                               name: userName,
                                               message: conversationModel?.message,
                                               date: conversationModel?.date,
                                               online: true,
                                               hasUnreadMessages: conversationModel?.isUnread ?? false)
            self.storage.people[userID] = model
            
            let people = self.sortPeople(Array(self.storage.people.values))
            
            DispatchQueue.main.async {
                self.didChangeConversationsListAction?(people)
                if userID == self.currentUserID {
                    self.currentUserStatus?(true)
                }
            }
        }
    }
    
    func didLostUser(userID: String) {
        backgroundQueue.async {
            self.storage.people.removeValue(forKey: userID)
            DispatchQueue.main.async {
                self.didChangeConversationsListAction?(Array(self.storage.people.values))
                if userID == self.currentUserID {
                    self.currentUserStatus?(false)
                }
            }
        }
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        print(error.localizedDescription)
    }
    
    func failedToStartAdvertising(error: Error) {
        print(error.localizedDescription)
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        backgroundQueue.async {
            self.updateMessages(with: text, isIncoming: true, for: fromUser)
            self.updateConversationsList(with: text, for: fromUser)
        }
    }
    
    private func updateConversationsList(with message: String, for user: String) {
        storage.people[user]?.message = message
        storage.people[user]?.date = Date()
        storage.people[user]?.hasUnreadMessages = user != currentUserID
        
        let people = sortPeople(Array(storage.people.values))
        
        DispatchQueue.main.async {
            self.didChangeConversationsListAction?(people)
        }
    }
    
    private func updateMessages(with message: String, isIncoming: Bool, for user: String) {
        let model = ConversationModel(message: message, date: Date(), isIncomingMessage: isIncoming, isUnread: user != currentUserID)
        
        if let messages = storage.messages[user] {
            storage.messages[user] = messages + [model]
        } else {
            storage.messages[user] = [model]
        }
        
        if user == self.currentUserID {
            DispatchQueue.main.async {
                self.didChangeMessagesAction?(self.storage.messages[user] ?? [])
            }
        }
    }
    
    private func sortPeople(_ people: [ConversationsListModel]) -> [ConversationsListModel] {
        return people.sorted { model1, model2 -> Bool in
            if let date1 = model1.date, let date2 = model2.date {
                return date1 > date2
            } else if model1.date != nil, model2.date == nil {
                return true
            } else if model1.date == nil, model2.date != nil {
                return false
            } else {
                if let name1 = model1.name, let name2 = model2.name {
                    return name1 > name2
                } else if model1.name != nil, model2.name == nil {
                    return true
                } else if model1.name == nil, model2.name != nil {
                    return false
                } else {
                    return true
                }
            }
        }
    }
}
