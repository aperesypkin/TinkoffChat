//
//  ProfileDataManager.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 04/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import CoreData

protocol IProfileDataManagerDelegate: class {
    func didLoadUser(name: String?, aboutMe: String?, imageData: Data?)
    func didSaveUser()
    func didReceiveSave(error: String)
    func didReceiveLoad(error: String)
}

protocol IProfileDataManager {
    var delegate: IProfileDataManagerDelegate? { get set }
    func saveProfile()
    func loadProfile()
    func set(name: String?)
    func set(aboutMe: String)
    func set(imageData: Data?)
}

class ProfileDataManager: IProfileDataManager {
    
    private struct State {
        var name: String?
        var aboutMe: String?
        var imageData: Data?
    }
    
    private var state = State()
    
    weak var delegate: IProfileDataManagerDelegate?
    
    private let profileService: IProfileService
    
    init(profileService: IProfileService) {
        self.profileService = profileService
    }
    
    func saveProfile() {
        profileService.save(name: state.name,
                            aboutMe: state.aboutMe,
                            imageData: state.imageData as NSData?)
    }
    
    func loadProfile() {
        profileService.load()
    }
    
    func set(name: String?) {
        state.name = name
    }
    
    func set(aboutMe: String) {
        state.aboutMe = aboutMe
    }
    
    func set(imageData: Data?) {
        state.imageData = imageData
    }
    
}

extension ProfileDataManager: IProfileServiceDelegate {
    func didReceiveSave(error: Error?) {
        let error = error?.localizedDescription ?? "ProfileService did receive save error"
        delegate?.didReceiveSave(error: error)
    }
    
    func didReceiveLoad(error: Error?) {
        let error = error?.localizedDescription ?? "ProfileService did receive load error"
        delegate?.didReceiveLoad(error: error)
    }
    
    func didLoad(user: AppUser) {
        delegate?.didLoadUser(name: user.name, aboutMe: user.aboutMe, imageData: user.image as Data?)
    }
    
    func didSaveUser() {
        delegate?.didSaveUser()
    }
}
