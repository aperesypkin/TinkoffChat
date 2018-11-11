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
    
    private let coreDataStack = CoreDataStack.shared
    
    private var communicator: Communicator = MultipeerCommunicator()
    
    init() {
        communicator.delegate = self
    }
    
    // !!! Теперь вместо этого метода будет FetchedResultController
//    func obtainMessages(for userID: String, completionHandler: @escaping ([ConversationModel]?) -> Void) {
//        coreDataStack.saveContext.perform {
//            let fetchRequest: NSFetchRequest<Conversation> = Conversation.fetchRequest()
//            //NSPredicate(format: "%K = %@", #keyPath(Dog.name), dogName)
//            fetchRequest.predicate = NSPredicate(format: "%K = %@", #keyPath(Conversation.identifier), userID)
//            do {
//                let conversations = try self.coreDataStack.saveContext.fetch(fetchRequest)
//                if let conversation = conversations.first {
//                    conversation
//                }
//            } catch {
//                print(error)
//            }
//        }
//
//
//        backgroundQueue.async {
//            self.storage.people[userID]?.hasUnreadMessages = false
//            let people = self.sortPeople(Array(self.storage.people.values))
//
//            self.storage.messages[userID]?.forEach { $0.markAsRead() }
//
//            DispatchQueue.main.async {
//                self.didChangeConversationsListAction?(people)
//                completionHandler(self.storage.messages[userID])
//            }
//        }
//    }
    
    func send(text: String, for userID: String) {
        communicator.sendMessage(string: text, to: userID) { isSuccess, error in
            if isSuccess {
                self.coreDataStack.saveContext.perform {
                    let conversationsFetchRequest: NSFetchRequest<Conversation> = Conversation.fetchRequest()
                    conversationsFetchRequest.predicate = NSPredicate(format: "%K = %@", #keyPath(Conversation.identifier), userID)
                    
                    do {
                        let result = try self.coreDataStack.saveContext.fetch(conversationsFetchRequest)
                        if let conversation = result.first {
                            let message = Message(context: self.coreDataStack.saveContext)
                            message.text = text
                            message.isIncomingMessage = false
                            message.date = NSDate()
                            message.isUnread = userID != self.currentUserID
                            
                            conversation.addToMessages(message)
                            conversation.lastMessage = message
                            
                            self.coreDataStack.performSave()
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                
//                self.backgroundQueue.async {
//                    self.updateMessages(with: message, isIncoming: false, for: userID)
//                    self.updateConversationsList(with: message, for: userID)
//                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func didFoundUser(userID: String, userName: String?) {
        coreDataStack.saveContext.perform {
            let conversationsFetchRequest: NSFetchRequest<Conversation> = Conversation.fetchRequest()
            conversationsFetchRequest.predicate = NSPredicate(format: "%K = %@", #keyPath(Conversation.identifier), userID)
            
            do {
                let result = try self.coreDataStack.saveContext.fetch(conversationsFetchRequest)
                if let conversation = result.first {
                    conversation.user?.isOnline = true
                    conversation.status = "Online"
                } else {
                    let conversation = Conversation(context: self.coreDataStack.saveContext)
                    let user = User(context: self.coreDataStack.saveContext)
                    
                    user.identifier = userID
                    user.isOnline = true
                    user.name = userName
                    
                    conversation.identifier = userID
                    conversation.status = "Online"
                    conversation.user = user
                }
            } catch {
                print(error.localizedDescription)
            }
            
            self.coreDataStack.performSave {
                DispatchQueue.main.async {
                    if userID == self.currentUserID {
                        self.currentUserStatus?(true)
                    }
                }
            }
        }
        
//        backgroundQueue.async {
//            let conversationModel = self.storage.messages[userID]?.last
//            let model = ConversationsListModel(userID: userID,
//                                               name: userName,
//                                               message: conversationModel?.message,
//                                               date: conversationModel?.date,
//                                               online: true,
//                                               hasUnreadMessages: conversationModel?.isUnread ?? false)
//            self.storage.people[userID] = model
//
//            let people = self.sortPeople(Array(self.storage.people.values))
//
//            DispatchQueue.main.async {
//                self.didChangeConversationsListAction?(people)
//                if userID == self.currentUserID {
//                    self.currentUserStatus?(true)
//                }
//            }
//        }
    }
    
    func didLostUser(userID: String) {
        coreDataStack.saveContext.perform {
            let conversationsFetchRequest: NSFetchRequest<Conversation> = Conversation.fetchRequest()
            conversationsFetchRequest.predicate = NSPredicate(format: "%K = %@", #keyPath(Conversation.identifier), userID)
            
            do {
                let result = try self.coreDataStack.saveContext.fetch(conversationsFetchRequest)
                if let conversation = result.first {
                    conversation.user?.isOnline = false
                    conversation.status = "History"
                    
                    self.coreDataStack.performSave {
                        DispatchQueue.main.async {
                            if userID == self.currentUserID {
                                self.currentUserStatus?(false)
                            }
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
//        backgroundQueue.async {
//            self.storage.people.removeValue(forKey: userID)
//            DispatchQueue.main.async {
//                self.didChangeConversationsListAction?(Array(self.storage.people.values))
//                if userID == self.currentUserID {
//                    self.currentUserStatus?(false)
//                }
//            }
//        }
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        print(error.localizedDescription)
    }
    
    func failedToStartAdvertising(error: Error) {
        print(error.localizedDescription)
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        coreDataStack.saveContext.perform {
            let conversationsFetchRequest: NSFetchRequest<Conversation> = Conversation.fetchRequest()
            conversationsFetchRequest.predicate = NSPredicate(format: "%K = %@", #keyPath(Conversation.identifier), fromUser)
            
            do {
                let result = try self.coreDataStack.saveContext.fetch(conversationsFetchRequest)
                if let conversation = result.first {
                    let message = Message(context: self.coreDataStack.saveContext)
                    message.text = text
                    message.isIncomingMessage = true
                    message.date = NSDate()
                    message.isUnread = fromUser != self.currentUserID
                    
                    conversation.addToMessages(message)
                    conversation.lastMessage = message
                    
                    self.coreDataStack.performSave()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
