//
//  FetchedResultControllerManager.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 11/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import CoreData

class FetchedResultControllerManager<ResultType: NSFetchRequestResult> {
    
    private let coreDataStack = CoreDataStack.shared
    
    private let fetchRequest: NSFetchRequest<ResultType>
    private let sectionNameKeyPath: String?
    private let cacheName: String?
    
    private var delegate: FetchedResultControllerManagerDelegate?
    
    var sectionsCount: Int {
        return fetchedResultController.sections?.count ?? 0
    }
    
    lazy var fetchedResultController: NSFetchedResultsController<ResultType> = {
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: coreDataStack.mainContext,
                                          sectionNameKeyPath: sectionNameKeyPath,
                                          cacheName: cacheName)
    }()
    
    init(fetchRequest: NSFetchRequest<ResultType>, sectionNameKeyPath: String?, cacheName: String?) {
        self.fetchRequest = fetchRequest
        self.sectionNameKeyPath = sectionNameKeyPath
        self.cacheName = cacheName
    }
    
    func numberOfObjects(at section: Int) -> Int {
        return fetchedResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func object(at indexPath: IndexPath) -> ResultType {
        return fetchedResultController.object(at: indexPath)
    }
    
    func name(for section: Int) -> String? {
        return fetchedResultController.sections?[section].name
    }
    
    func performFetch(for tableView: UITableView) {
        delegate = FetchedResultControllerManagerDelegate(tableView: tableView)
        fetchedResultController.delegate = delegate
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
