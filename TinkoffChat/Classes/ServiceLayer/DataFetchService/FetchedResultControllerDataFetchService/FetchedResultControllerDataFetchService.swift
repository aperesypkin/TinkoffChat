//
//  FetchedResultControllerDataFetchService.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 11/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import CoreData

class FetchedResultControllerDataFetchService<ResultType: NSFetchRequestResult>: NSObject, IDataFetchService, NSFetchedResultsControllerDelegate {
    
    weak var delegate: IDataFetchServiceDelegate?
    
    private let coreDataStack: ICoreDataStack

    private let fetchRequest: NSFetchRequest<ResultType>
    private let sectionNameKeyPath: String?
    private let cacheName: String?
    
    private lazy var fetchedResultController: NSFetchedResultsController<ResultType> = {
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: coreDataStack.mainContext,
                                          sectionNameKeyPath: sectionNameKeyPath,
                                          cacheName: cacheName)
    }()
    
    init(coreDataStack: ICoreDataStack, fetchRequest: NSFetchRequest<ResultType>, sectionNameKeyPath: String?, cacheName: String?) {
        self.coreDataStack = coreDataStack
        self.fetchRequest = fetchRequest
        self.sectionNameKeyPath = sectionNameKeyPath
        self.cacheName = cacheName
    }
    
    func sectionsCount() -> Int {
        return fetchedResultController.sections?.count ?? 0
    }
    
    func numberOfObjects(at section: Int) -> Int {
        return fetchedResultController.sections?[section].numberOfObjects ?? 0
    }

    func object(at indexPath: IndexPath) -> NSFetchRequestResult {
        return fetchedResultController.object(at: indexPath)
    }

    func name(for section: Int) -> String? {
        return fetchedResultController.sections?[section].name
    }
    
    func performFetch() {
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.dataWillChange()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        delegate?.objectDidChange(at: indexPath, for: type, newIndexPath: newIndexPath)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.dataDidChange()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        delegate?.sectionDidChange(atSectionIndex: sectionIndex, for: type)
    }
    
}
