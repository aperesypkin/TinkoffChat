//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 03/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import UIKit
import CoreData

private struct Identifiers {
    static let conversationSequeIdentifier = "ConversationSequeIdentifier"
    static let themesSequeIdentifier = "ThemesSequeIdentifier"
    static let themesSwiftSequeIdentifier = "ThemesSwiftSequeIdentifier"
}

final class ConversationsListViewController: BaseViewController {
    
    struct ViewModel {
        let name: String
        let message: String
        let font: UIFont
        let date: String
        let backgroundColor: UIColor
        let online: Bool
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.register(ConversationsListCell.self)
        }
    }
    
    private let communicationManager = CommunicationManager()
    
    private let themes = [UIColor.black: Theme.black,
                          UIColor.blue: Theme.blue,
                          UIColor.white: Theme.white]
    
    private lazy var actionSheetController: UIAlertController = {
        let actionSheetController = UIAlertController(title: "Выберите View Controller", message: nil, preferredStyle: .actionSheet)
        
        let objectiveViewControllerAction = UIAlertAction(title: "Objective-C View Controller", style: .default) { [weak self] _ in
            guard let `self` = self else { return }
            self.performSegue(withIdentifier: Identifiers.themesSequeIdentifier, sender: nil)
        }
        
        let swiftViewControllerAction = UIAlertAction(title: "Swift View Controller", style: .default) { [weak self] _ in
            guard let `self` = self else { return }
            self.performSegue(withIdentifier: Identifiers.themesSwiftSequeIdentifier, sender: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        actionSheetController.addAction(objectiveViewControllerAction)
        actionSheetController.addAction(swiftViewControllerAction)
        actionSheetController.addAction(cancelAction)
        
        return actionSheetController
    }()
    
    private lazy var fetchedResultController: NSFetchedResultsController<Conversation> = {
        let fetchRequest: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        
        let sectionSort = NSSortDescriptor(key: #keyPath(Conversation.status), ascending: false)
        let dateSort = NSSortDescriptor(key: #keyPath(Conversation.lastMessage.date), ascending: true)
        let nameSort = NSSortDescriptor(key: #keyPath(Conversation.user.name), ascending: true)
        
        fetchRequest.sortDescriptors = [sectionSort, dateSort, nameSort]
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                 managedObjectContext: CoreDataStack.shared.mainContext,
                                                                 sectionNameKeyPath: #keyPath(Conversation.status),
                                                                 cacheName: nil)
        fetchedResultController.delegate = self
        return fetchedResultController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
            
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.conversationSequeIdentifier {
            if let conversationViewController = segue.destination.contents as? ConversationViewController {
                guard let conversation = sender as? Conversation else { return }
                conversationViewController.title = conversation.user?.name
                conversationViewController.user = conversation.user
                conversationViewController.communicationManager = communicationManager
            }
        } else if segue.identifier == Identifiers.themesSequeIdentifier {
            if let themesViewController = segue.destination.contents as? ThemesViewController {
                themesViewController.delegate = self
            }
        } else if segue.identifier == Identifiers.themesSwiftSequeIdentifier {
            if let themesSwiftViewController = segue.destination.contents as? ThemesSwiftViewController {
                themesSwiftViewController.themeButtonAction = { [weak self] selectedTheme in
                    guard let `self` = self else { return }
                    self.logThemeChanging(selectedTheme: selectedTheme)
                }
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    @IBAction func didTapChooseThemeButton(_ sender: UIBarButtonItem) {
        present(actionSheetController, animated: true)
    }
    
    private func logThemeChanging(selectedTheme: UIColor) {
        print("Selected theme's color is \(selectedTheme.string)")
        if let theme = themes[selectedTheme] {
            theme.apply()
            ThemeManager.shared.save(theme: theme)
        }
    }

}

// MARK: - UITableViewDataSource
extension ConversationsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let conversation = fetchedResultController.object(at: indexPath)
        
        let cell: ConversationsListCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: conversation.viewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = fetchedResultController.sections?[section]
        return sectionInfo?.name
    }
}

// MARK: - UITableViewDelegate
extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let conversation = fetchedResultController.object(at: indexPath)
        performSegue(withIdentifier: Identifiers.conversationSequeIdentifier, sender: conversation)
    }
}

// MARK: - ​ThemesViewControllerDelegate
extension ConversationsListViewController: ​ThemesViewControllerDelegate {
    func themesViewController(_ controller: ThemesViewController, didSelectTheme selectedTheme: UIColor) {
        logThemeChanging(selectedTheme: selectedTheme)
    }
}

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert: tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete: tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update: tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert: tableView.insertSections(indexSet, with: .automatic)
        case .delete: tableView.deleteSections(indexSet, with: .automatic)
        default: break
        }
    }
}
