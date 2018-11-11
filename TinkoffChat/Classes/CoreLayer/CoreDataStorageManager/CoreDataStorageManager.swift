//
//  CoreDataStorageManager.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 11/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import CoreData

class CoreDataStorageManager {
    
    private let coreDataStack = CoreDataStack.shared
    
    func saveFoundedUser(userID: String, userName: String?) {
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
            
            self.coreDataStack.performSave()
        }
    }
    
    func saveLostUser(userID: String) {
        coreDataStack.saveContext.perform {
            let conversationsFetchRequest: NSFetchRequest<Conversation> = Conversation.fetchRequest()
            conversationsFetchRequest.predicate = NSPredicate(format: "%K = %@", #keyPath(Conversation.identifier), userID)
            
            do {
                let result = try self.coreDataStack.saveContext.fetch(conversationsFetchRequest)
                if let conversation = result.first {
                    if let messages = conversation.messages, messages.count > 0 {
                        conversation.user?.isOnline = false
                        conversation.status = "History"
                    } else {
                        self.coreDataStack.saveContext.delete(conversation)
                    }
                    
                    self.coreDataStack.performSave()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveReceivedMessage(text: String, fromUser: String, toUser: String, isUnread: Bool) {
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
                    message.isUnread = isUnread
                    
                    conversation.addToMessages(message)
                    conversation.lastMessage = message
                    
                    self.coreDataStack.performSave()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveSendMessage(text: String, for userID: String) {
        coreDataStack.saveContext.perform {
            let conversationsFetchRequest: NSFetchRequest<Conversation> = Conversation.fetchRequest()
            conversationsFetchRequest.predicate = NSPredicate(format: "%K = %@", #keyPath(Conversation.identifier), userID)
            
            do {
                let result = try self.coreDataStack.saveContext.fetch(conversationsFetchRequest)
                if let conversation = result.first {
                    let message = Message(context: self.coreDataStack.saveContext)
                    message.text = text
                    message.isIncomingMessage = false
                    message.date = NSDate()
                    message.isUnread = false
                    
                    conversation.addToMessages(message)
                    conversation.lastMessage = message
                    
                    self.coreDataStack.performSave()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func markMessagesAsRead(for user: String) {
        coreDataStack.saveContext.perform {
            let messagesFetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
            messagesFetchRequest.predicate = NSPredicate(format: "%K = %@", #keyPath(Message.conversation.identifier), user)
            
            do {
                let messages = try self.coreDataStack.saveContext.fetch(messagesFetchRequest)
                messages.filter { $0.isUnread }.forEach { $0.isUnread = false }
                self.coreDataStack.performSave()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func moveAllConversationsToHistory() {
        coreDataStack.saveContext.perform {
            let conversationsFetchRequest: NSFetchRequest<Conversation> = Conversation.fetchRequest()
            
            do {
                let conversations = try self.coreDataStack.saveContext.fetch(conversationsFetchRequest)
                conversations.filter { $0.status == "Online" }.forEach {
                    $0.status = "History"
                    $0.user?.isOnline = false
                }
                self.coreDataStack.performSave()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
