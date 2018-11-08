//
//  CoreDataStack.swift
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

class CoreDataStack {
    
    static let shared = CoreDataStack(dataModelName: "TinkoffChat")
    
    private let dataModelName: String
    
    init(dataModelName: String) {
        self.dataModelName = dataModelName
    }
    
    private var storeURL: URL {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsUrl.appendingPathComponent(dataModelName).appendingPathExtension(.dataStoreExtension)
    }
    
    private lazy var manageObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: dataModelName, withExtension: .dataModelExtension)!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: manageObjectModel)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL)
        } catch {
            assert(false, "Error adding store: \(error)")
        }
        return coordinator
    }()
    
    private lazy var masterContext: NSManagedObjectContext = {
        var masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        masterContext.persistentStoreCoordinator = persistentStoreCoordinator
        masterContext.mergePolicy = NSOverwriteMergePolicy
        return masterContext
    }()
    
    private(set) lazy var mainContext: NSManagedObjectContext = {
        var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.parent = masterContext
        mainContext.mergePolicy = NSOverwriteMergePolicy
        return mainContext
    }()
    
    private(set) lazy var saveContext: NSManagedObjectContext = {
        var saveContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        saveContext.parent = mainContext
        saveContext.mergePolicy = NSOverwriteMergePolicy
        return saveContext
    }()
    
    func performSave(with context: NSManagedObjectContext, completion: (() -> Void)? = nil) {
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
    
    func performSave(completion: (() -> Void)? = nil) {
        performSave(with: saveContext, completion: completion)
    }
    
}
