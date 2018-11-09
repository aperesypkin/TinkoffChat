//
//  Conversation+CoreDataProperties.swift
//  
//
//  Created by Alexander Peresypkin on 09/11/2018.
//
//

import Foundation
import CoreData

extension Conversation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Conversation> {
        return NSFetchRequest<Conversation>(entityName: "Conversation")
    }

    @NSManaged public var userID: String?
    @NSManaged public var name: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var isOnline: Bool
    @NSManaged public var hasUnreadMessages: Bool
    @NSManaged public var messages: NSSet?

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
