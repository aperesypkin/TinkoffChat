//
//  CoreAssembly.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 15/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    var coreDataStack: ICoreDataStack { get }
    var storage: ICoreDataStorage { get }
    var communicator: ICommunicator { get }
    var dataManager: IDataManager { get }
    var requestClient: IRequestClient { get }
}

class CoreAssembly: ICoreAssembly {
    
    var coreDataStack: ICoreDataStack = CommonCoreDataStack.shared
    
    var storage: ICoreDataStorage {
        return CommonCoreDataStorage(coreDataStack: coreDataStack)
    }
    
    lazy var communicator: ICommunicator = MultipeerCommunicator(coreDataStack: coreDataStack)
    
    var dataManager: IDataManager = GCDDataManager()
    
    var requestClient: IRequestClient = CommonRequestClient()
    
}
