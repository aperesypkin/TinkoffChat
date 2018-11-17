//
//  PresentationAssembly.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 15/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

protocol IPresentationAssembly {
    func conversationsListViewController() -> ConversationsListViewController
    func conversationViewController(userID: String, isUserOnline: Bool) -> ConversationViewController
    func profileViewController() -> ProfileViewController
}

class PresentationAssembly: IPresentationAssembly {
    
    private let serviceAssembly: IServicesAssembly

    init(serviceAssembly: IServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func conversationsListViewController() -> ConversationsListViewController {
        var dataManager = conversationsListDataManager()
        let viewController = ConversationsListViewController(dataManager: dataManager,
                                                             presentationAssembly: self)
        dataManager.delegate = viewController
        return viewController
    }
    
    private func conversationsListDataManager() -> IConversationsListDataManager {
        var service = serviceAssembly.conversationsListService()
        let dataManager = ConversationsListDataManager(conversationsListService: service,
                                                       communicationService: serviceAssembly.communicationService)
        service.delegate = dataManager
        return dataManager
    }
    
    func conversationViewController(userID: String, isUserOnline: Bool) -> ConversationViewController {
        var dataManager = conversationDataManager(userID: userID)
        let viewController = ConversationViewController(dataManager: dataManager, userID: userID, isUserOnline: isUserOnline)
        dataManager.delegate = viewController
        return viewController
    }
    
    private func conversationDataManager(userID: String) -> IConversationDataManager {
        var conversationService = serviceAssembly.conversationService(userID: userID)
        var communicationService = serviceAssembly.communicationService
        let dataManager = ConversationDataManager(conversationService: conversationService,
                                                  communicationService: communicationService)
        conversationService.delegate = dataManager
        communicationService.delegate = dataManager
        return dataManager
    }
    
    func profileViewController() -> ProfileViewController {
        var dataManager = profileDataManager()
        let viewController = ProfileViewController(dataManager: dataManager)
        dataManager.delegate = viewController
        return viewController
    }
    
    private func profileDataManager() -> IProfileDataManager {
        var service = serviceAssembly.profileService()
        let dataManager = ProfileDataManager(profileService: service)
        service.delegate = dataManager
        return dataManager
    }
    
}
