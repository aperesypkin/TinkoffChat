//
//  ConversationDataManager.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 17/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import CoreData

protocol IConversationDataManagerDelegate {
    func dataWillChange()
    func dataDidChange()
    func objectDidChange(at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    func didChange(user: String, online status: Bool)
}

protocol IConversationDataManager {
    var delegate: IConversationDataManagerDelegate? { get set }
    func performFetchData()
    func numberOfObjects(at section: Int) -> Int
    func object(at indexPath: IndexPath) -> Message?
    func send(text: String, for userID: String)
    func markMessagesAsRead(for userID: String)
}

class ConversationDataManager: IConversationDataManager {
    
    var delegate: IConversationDataManagerDelegate?
    
    private let conversationService: IDataFetch
    private let communicationService: ICommunicationService
    
    init(conversationService: IDataFetch, communicationService: ICommunicationService) {
        self.conversationService = conversationService
        self.communicationService = communicationService
    }
    
    func send(text: String, for userID: String) {
        communicationService.send(text: text, for: userID)
    }
    
    func markMessagesAsRead(for userID: String) {
        communicationService.markMessagesAsRead(for: userID)
    }
    
    func performFetchData() {
        conversationService.performFetch()
    }
    
    func numberOfObjects(at section: Int) -> Int {
        return conversationService.numberOfObjects(at: section)
    }
    
    func object(at indexPath: IndexPath) -> Message? {
        if let object = conversationService.object(at: indexPath) as? Message {
            return object
        } else {
            return nil
        }
    }
    
}

extension ConversationDataManager: IDataFetchDelegate {
    func dataWillChange() {
        delegate?.dataWillChange()
    }
    
    func dataDidChange() {
        delegate?.dataDidChange()
    }
    
    func objectDidChange(at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        delegate?.objectDidChange(at: indexPath, for: type, newIndexPath: newIndexPath)
    }
    
    func sectionDidChange(atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    }
}

extension ConversationDataManager: ICommunicationDelegate {
    func didLostUser(userID: String) {
        delegate?.didChange(user: userID, online: false)
    }
    
    func didFoundUser(userID: String) {
        delegate?.didChange(user: userID, online: true)
    }
}
