//
//  User+CoreDataProperties.swift
//  
//
//  Created by Alexander Peresypkin on 10/11/2018.
//
//

import Foundation
import CoreData

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var isOnline: Bool
    @NSManaged public var name: String?
    @NSManaged public var identifier: String?
    @NSManaged public var conversation: Conversation?

}
