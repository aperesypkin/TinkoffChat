//
//  NSManagedObjectContext+FetchRequest.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 12/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {
    func fetch<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [T] {
        let request: NSFetchRequest<NSFetchRequestResult> = type.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        if let result = try self.fetch(request) as? [T] {
            return result
        } else {
            throw FetchError.resultsNotFound
        }
    }
    
    private enum FetchError: Error {
        case resultsNotFound
    }
}
