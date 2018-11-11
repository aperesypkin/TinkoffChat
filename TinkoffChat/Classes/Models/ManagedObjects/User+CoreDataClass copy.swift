//
//  User+CoreDataClass.swift
//  
//
//  Created by Alexander Peresypkin on 10/11/2018.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    static func fetchRequestUsersAreOnline(context: NSManagedObjectContext) -> NSFetchRequest<User>? {
        let model = context.persistentStoreCoordinator?.managedObjectModel
        let request = model?.fetchRequestTemplate(forName: "UsersAreOnline") as? NSFetchRequest<User>
        return request
    }
    
    static func fetchRequestUsers(context: NSManagedObjectContext, identifier: String) -> NSFetchRequest<User>? {
        let model = context.persistentStoreCoordinator?.managedObjectModel
        let request = model?.fetchRequestFromTemplate(withName: "UserWithID", substitutionVariables: ["identifier": identifier]) as? NSFetchRequest<User>
        return request
    }
}
