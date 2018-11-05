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
        var name: String? = "Unnamed"
        var aboutMe: String? = "Информация о пользователе"
        var imageData: Data?
    }
    
    var state = State()
    
    private let coreDataStack = CoreDataStack.shared
    
    func saveProfile(completion: @escaping (Bool, Error?) -> Void) {
        let profileFetch: NSFetchRequest<Profile> = Profile.fetchRequest()
        do {
            let results = try coreDataStack.saveContext.fetch(profileFetch)
            if let profile = results.first {
                setProfile(profile)
                coreDataStack.performSave() {
                    DispatchQueue.main.async {
                        completion(true, nil)
                    }
                }
            } else {
                completion(false, nil)
            }
        } catch {
            completion(false, error)
        }
    }
    
    func loadProfile(completion: @escaping (State?, Error?) -> Void) {
        let profileFetch: NSFetchRequest<Profile> = Profile.fetchRequest()
        do {
            let results = try coreDataStack.mainContext.fetch(profileFetch)
            if results.isEmpty {
                let profile = Profile(context: coreDataStack.saveContext)
                setProfile(profile)
                coreDataStack.performSave() {
                    DispatchQueue.main.async {
                        completion(self.state, nil)
                    }
                }
            } else if let profile = results.first {
                state.name = profile.name
                state.aboutMe = profile.aboutMe
                state.imageData = profile.image as Data?
                completion(state, nil)
            }
        } catch {
            completion(nil, error)
        }
    }
    
    private func setProfile(_ profile: Profile) {
        profile.name = state.name
        profile.aboutMe = state.aboutMe
        profile.image = state.imageData as NSData?
    }
    
}
