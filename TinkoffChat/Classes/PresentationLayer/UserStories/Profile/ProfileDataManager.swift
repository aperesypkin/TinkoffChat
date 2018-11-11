//
//  ProfileDataManager.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 04/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import CoreData

class ProfileDataManager {
    
    struct State {
        var name: String?
        var aboutMe: String?
        var imageData: Data?
    }
    
    var state = State()
    
    private let coreDataStack = CoreDataStack.shared
    
    func saveProfile(completion: @escaping (Bool, Error?) -> Void) {
        coreDataStack.saveContext.perform {
            do {
                let users = try AppUser.fetchUsers(context: self.coreDataStack.saveContext)
                
                if let user = users.first {
                    self.setUserInfo(user)
                    self.coreDataStack.performSave {
                        DispatchQueue.main.async {
                            completion(true, nil)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(false, nil)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
    }
    
    func loadProfile(completion: @escaping (State?, Error?) -> Void) {
        do {
            let users = try AppUser.fetchUsers(context: coreDataStack.mainContext)
            if let user = users.first {
                state.name = user.name
                state.aboutMe = user.aboutMe
                state.imageData = user.image as Data?
                completion(state, nil)
            }
        } catch {
            completion(nil, error)
        }
    }
    
    private func setUserInfo(_ user: AppUser) {
        user.name = state.name
        user.aboutMe = state.aboutMe
        user.image = state.imageData as NSData?
    }
    
}
