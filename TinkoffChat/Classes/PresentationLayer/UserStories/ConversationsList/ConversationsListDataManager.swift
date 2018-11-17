//
//  ConversationsListDataManager.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 15/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import CoreData

protocol IConversationsListDataManagerDelegate: class {
    func dataWillChange()
    func dataDidChange()
    func objectDidChange(at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    func sectionDidChange(atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType)
}

protocol IConversationsListDataManager {
    var delegate: IConversationsListDataManagerDelegate? { get set }
    func performFetchData()
    func sectionsCount() -> Int
    func numberOfObjects(at section: Int) -> Int
    func object(at indexPath: IndexPath) -> Conversation?
    func name(for section: Int) -> String?
}

class ConversationsListDataManager: IConversationsListDataManager {
    
    weak var delegate: IConversationsListDataManagerDelegate?
    
    private let conversationsListService: IDataFetchService
    private let communicationService: ICommunicationService
    
    init(conversationsListService: IDataFetchService, communicationService: ICommunicationService) {
        self.conversationsListService = conversationsListService
        self.communicationService = communicationService
        self.communicationService.startComminucation()
    }
    
    func performFetchData() {
        conversationsListService.performFetch()
    }
    
    func sectionsCount() -> Int {
        return conversationsListService.sectionsCount()
    }
    
    func numberOfObjects(at section: Int) -> Int {
        return conversationsListService.numberOfObjects(at: section)
    }
    
    func object(at indexPath: IndexPath) -> Conversation? {
        if let object = conversationsListService.object(at: indexPath) as? Conversation {
            return object
        } else {
            return nil
        }
    }
    
    func name(for section: Int) -> String? {
        return conversationsListService.name(for: section)
    }
    
}

extension ConversationsListDataManager: IDataFetchServiceDelegate {
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
        delegate?.sectionDidChange(atSectionIndex: sectionIndex, for: type)
    }
    
}
