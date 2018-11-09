//
//  Message+CoreDataProperties.swift
//  
//
//  Created by Alexander Peresypkin on 09/11/2018.
//
//

import Foundation
import CoreData

extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var text: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var isIncomingMessage: Bool
    @NSManaged public var isUnread: Bool
    @NSManaged public var conversation: Conversation?

}
