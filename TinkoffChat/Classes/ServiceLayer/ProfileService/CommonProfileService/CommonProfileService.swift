//
//  CommonProfileService.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 17/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

class CommonProfileService: IProfileService {
    
    weak var delegate: IProfileServiceDelegate?
    
    private let coreDataStack: ICoreDataStack
    
    init(coreDataStack: ICoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func save(name: String?, aboutMe: String?, imageData: NSData?) {
        coreDataStack.saveContext.perform {
            do {
                let users = try AppUser.fetchUsers(context: self.coreDataStack.saveContext)
                
                if let user = users.first {
                    user.name = name
                    user.aboutMe = aboutMe
                    user.image = imageData
                    self.coreDataStack.performSave {
                        DispatchQueue.main.async {
                            self.delegate?.didSaveUser()
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.delegate?.didReceiveSave(error: nil)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.delegate?.didReceiveSave(error: error)
                }
            }
        }
    }
    
    func load() {
        do {
            let users = try AppUser.fetchUsers(context: coreDataStack.mainContext)
            if let user = users.first {
                delegate?.didLoad(user: user)
            } else {
                delegate?.didReceiveLoad(error: nil)
            }
        } catch {
            delegate?.didReceiveLoad(error: error)
        }
    }
    
}
