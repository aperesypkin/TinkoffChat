//
//  CommonCoreDataStack.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 31/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import CoreData

private extension String {
    static let dataModelExtension = "momd"
    static let dataStoreExtension = "sqlite"
}

class CommonCoreDataStack: ICoreDataStack {
    
    static let shared = CommonCoreDataStack(dataModelName: "TinkoffChat")
    
    let dataModelName: String
    
    init(dataModelName: String) {
        self.dataModelName = dataModelName
    }
    
    var storeURL: URL {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsUrl.appendingPathComponent(dataModelName).appendingPathExtension(.dataStoreExtension)
    }
    
    lazy var manageObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: dataModelName, withExtension: .dataModelExtension)!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: manageObjectModel)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL)
        } catch {
            assert(false, "Error adding store: \(error)")
        }
        return coordinator
    }()
    
    lazy var masterContext: NSManagedObjectContext = {
        var masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        masterContext.persistentStoreCoordinator = persistentStoreCoordinator
        masterContext.mergePolicy = NSOverwriteMergePolicy
        return masterContext
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.parent = masterContext
        mainContext.mergePolicy = NSOverwriteMergePolicy
        return mainContext
    }()
    
    lazy var saveContext: NSManagedObjectContext = {
        var saveContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        saveContext.parent = mainContext
        saveContext.mergePolicy = NSOverwriteMergePolicy
        return saveContext
    }()
    
    func performSave() {
        performSave(with: saveContext)
    }
    
    func performSave(completion: (() -> Void)?) {
        performSave(with: saveContext, completion: completion)
    }
    
    func performSave(with context: NSManagedObjectContext) {
        performSave(with: context, completion: nil)
    }
    
    func performSave(with context: NSManagedObjectContext, completion: (() -> Void)?) {
        context.perform {
            guard context.hasChanges else {
                completion?()
                return
            }
            
            do {
                try context.save()
            } catch {
                print("Context save error: \(error)")
            }
            
            if let parentContext = context.parent {
                self.performSave(with: parentContext, completion: completion)
            } else {
                completion?()
            }
        }
    }
    
}
