//
//  ServicesAssembly.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 15/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import CoreData

protocol IServicesAssembly {
    var communicationService: ICommunicationService { get }
    var themeService: IThemeService { get }
    func conversationsListService() -> IDataFetchService
    func conversationService(userID: String) -> IDataFetchService
    func profileService() -> IProfileService
}

class ServicesAssembly: IServicesAssembly {
    
    private let coreAssembly: ICoreAssembly
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var communicationService: ICommunicationService = {
        var communicator = coreAssembly.communicator
        let observer = CommonCommunicationService(communicator: communicator, storage: coreAssembly.storage)
        communicator.delegate = observer
        return observer
    }()
    
    lazy var themeService: IThemeService = {
        return CommonThemeService(dataManager: coreAssembly.dataManager)
    }()
    
    func conversationsListService() -> IDataFetchService {
        let fetchRequest: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        
        let sectionSort = NSSortDescriptor(key: #keyPath(Conversation.status), ascending: false)
        let dateSort = NSSortDescriptor(key: #keyPath(Conversation.lastMessage.date), ascending: false)
        let nameSort = NSSortDescriptor(key: #keyPath(Conversation.user.name), ascending: false)

        fetchRequest.sortDescriptors = [sectionSort, dateSort, nameSort]
        
        return FetchedResultControllerDataFetchService(coreDataStack: coreAssembly.coreDataStack,
                                              fetchRequest: fetchRequest,
                                              sectionNameKeyPath: #keyPath(Conversation.status),
                                              cacheName: nil)
    }
    
    func conversationService(userID: String) -> IDataFetchService {
        let fetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", #keyPath(Message.conversation.identifier), userID)
        
        let dateSort = NSSortDescriptor(key: #keyPath(Message.date), ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        return FetchedResultControllerDataFetchService(coreDataStack: coreAssembly.coreDataStack,
                                              fetchRequest: fetchRequest,
                                              sectionNameKeyPath: nil,
                                              cacheName: nil)
    }
    
    func profileService() -> IProfileService {
        return CommonProfileService(coreDataStack: coreAssembly.coreDataStack)
    }
    
}
