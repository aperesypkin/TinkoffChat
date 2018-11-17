//
//  IProfileServiceDelegate.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 17/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

protocol IProfileServiceDelegate: class {
    func didLoad(user: AppUser)
    func didSaveUser()
    func didReceiveSave(error: Error?)
    func didReceiveLoad(error: Error?)
}
