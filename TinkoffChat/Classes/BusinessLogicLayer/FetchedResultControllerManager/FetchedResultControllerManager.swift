//
//  FetchedResultControllerManager.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 11/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import CoreData

class FetchedResultControllerManager<ManagedObject: NSManagedObject> {
    
    private let coreDataStack = CoreDataStack.shared
    
    private let fetchedResultController: NSFetchedResultsController<ManagedObject>
    
    var sectionsCount: Int {
        return fetchedResultController.sections?.count ?? 0
    }
    
    init(fetchRequest: NSFetchRequest<ManagedObject>, sectionNameKeyPath: String?, cacheName name: String?) {
        self.fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: coreDataStack.mainContext,
                                                                  sectionNameKeyPath: sectionNameKeyPath,
                                                                  cacheName: name)
    }
    
    func numberOfObjects(for section: Int) -> Int {
        return fetchedResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func object(at indexPath: IndexPath) -> ManagedObject {
        return fetchedResultController.object(at: indexPath)
    }
    
    func name(for section: Int) -> String? {
        return fetchedResultController.sections?[section].name
    }
    
    func performFetch(for tableView: UITableView) {
        let delegate = FetchedResultControllerManagerDelegate(tableView: tableView)
        fetchedResultController.delegate = delegate
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }

}
