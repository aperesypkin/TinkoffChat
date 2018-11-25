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
    func themeListViewController() -> ThemeListViewController
    func avatarGalleryViewController() -> AvatarGalleryViewController
}

class PresentationAssembly: IPresentationAssembly {
    
    private let serviceAssembly: IServicesAssembly

    init(serviceAssembly: IServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    // MARK: - ConversationsListViewController
    
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
                                                       communicationService: serviceAssembly.communicationService,
                                                       themeService: serviceAssembly.themeService)
        service.delegate = dataManager
        return dataManager
    }
    
    // MARK: - ConversationViewController
    
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
    
    // MARK: - ProfileViewController
    
    func profileViewController() -> ProfileViewController {
        var dataManager = profileDataManager()
        let viewController = ProfileViewController(dataManager: dataManager, presentationAssembly: self)
        dataManager.delegate = viewController
        return viewController
    }
    
    private func profileDataManager() -> IProfileDataManager {
        var service = serviceAssembly.profileService()
        let dataManager = ProfileDataManager(profileService: service)
        service.delegate = dataManager
        return dataManager
    }
    
    // MARK: - ThemeListViewController
    
    func themeListViewController() -> ThemeListViewController {
        return ThemeListViewController(dataManager: themeListDataManager())
    }
    
    private func themeListDataManager() -> IThemeListDataManager {
        return ThemeListDataManager(themeService: serviceAssembly.themeService)
    }
    
    // MARK: - AvatarGalleryViewController
    
    func avatarGalleryViewController() -> AvatarGalleryViewController {
        let dataManager = avatarGalleryDataManager()
        let viewController = AvatarGalleryViewController(dataManager: dataManager)
        return viewController
    }
    
    private func avatarGalleryDataManager() -> IAvatarGalleryDataManager {
        return AvatarGalleryDataManager(avatarGalleryService: serviceAssembly.avatarGalleryService())
    }
    
}
