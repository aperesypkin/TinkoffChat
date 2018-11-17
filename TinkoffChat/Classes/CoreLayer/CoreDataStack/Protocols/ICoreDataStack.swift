//
//  ICoreDataStack.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 17/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import CoreData

protocol ICoreDataStack {
    var mainContext: NSManagedObjectContext { get }
    var saveContext: NSManagedObjectContext { get }
    
    func performSave()
    func performSave(completion: (() -> Void)?)
    func performSave(with context: NSManagedObjectContext)
    func performSave(with context: NSManagedObjectContext, completion: (() -> Void)?)
}
