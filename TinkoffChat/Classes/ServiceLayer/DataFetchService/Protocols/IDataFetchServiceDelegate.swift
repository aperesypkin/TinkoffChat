//
//  IDataFetchServiceDelegate.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 17/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import CoreData

protocol IDataFetchServiceDelegate: class {
    func dataWillChange()
    func dataDidChange()
    func objectDidChange(at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    func sectionDidChange(atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType)
}
