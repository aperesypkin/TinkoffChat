//
//  AppUser+CoreDataClass.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 12/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//
//

import Foundation
import CoreData

@objc(AppUser)
public class AppUser: NSManagedObject {
    static func fetchUsers(context: NSManagedObjectContext) throws -> [AppUser] {
        let request: NSFetchRequest<AppUser> = AppUser.fetchRequest()
        let results = try context.fetch(request)
        return results
    }
}
