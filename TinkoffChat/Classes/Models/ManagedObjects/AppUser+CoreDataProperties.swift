//
//  AppUser+CoreDataProperties.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 12/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//
//

import Foundation
import CoreData

extension AppUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppUser> {
        return NSFetchRequest<AppUser>(entityName: "AppUser")
    }

    @NSManaged public var aboutMe: String?
    @NSManaged public var image: NSData?
    @NSManaged public var name: String?

}
