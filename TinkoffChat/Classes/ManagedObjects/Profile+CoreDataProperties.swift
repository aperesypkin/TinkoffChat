//
//  Profile+CoreDataProperties.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 03/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//
//

import Foundation
import CoreData

extension Profile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var name: String?
    @NSManaged public var aboutMe: String?
    @NSManaged public var image: NSData?

}
