//
//  Profile+CoreDataProperties.swift
//  
//
//  Created by Alexander Peresypkin on 09/11/2018.
//
//

import Foundation
import CoreData

extension Profile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var aboutMe: String?
    @NSManaged public var image: NSData?
    @NSManaged public var name: String?

}
