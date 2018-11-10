//
//  Conversation+CoreDataProperties.swift
//  
//
//  Created by Alexander Peresypkin on 10/11/2018.
//
//

import Foundation
import CoreData

extension Conversation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Conversation> {
        return NSFetchRequest<Conversation>(entityName: "Conversation")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var messages: NSSet?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for messages
extension Conversation {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: Message)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: Message)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}
