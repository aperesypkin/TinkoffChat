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
    
    private lazy var dataManager: FetchedResultControllerManager<Conversation> = {
        let fetchRequest: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        
        let sectionSort = NSSortDescriptor(key: #keyPath(Conversation.status), ascending: false)
        let dateSort = NSSortDescriptor(key: #keyPath(Conversation.lastMessage.date), ascending: false)
        let nameSort = NSSortDescriptor(key: #keyPath(Conversation.user.name), ascending: false)
        
        fetchRequest.sortDescriptors = [sectionSort, dateSort, nameSort]
        
        return FetchedResultControllerManager(fetchRequest: fetchRequest,
                                              sectionNameKeyPath: #keyPath(Conversation.status),
                                              cacheName: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.performFetch(for: tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.conversationSequeIdentifier {
            if let conversationViewController = segue.destination.contents as? ConversationViewController {
                guard let conversation = sender as? Conversation else { return }
                conversationViewController.title = conversation.user?.name
                conversationViewController.isUserOnline = conversation.user?.isOnline
                conversationViewController.userID = conversation.user?.identifier
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
        return dataManager.sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.numberOfObjects(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let conversation = dataManager.object(at: indexPath)
        
        let cell: ConversationsListCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: conversation.viewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataManager.name(for: section)
    }
}

// MARK: - UITableViewDelegate
extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let conversation = dataManager.object(at: indexPath)
        performSegue(withIdentifier: Identifiers.conversationSequeIdentifier, sender: conversation)
    }
}

// MARK: - ​ThemesViewControllerDelegate
extension ConversationsListViewController: ​ThemesViewControllerDelegate {
    func themesViewController(_ controller: ThemesViewController, didSelectTheme selectedTheme: UIColor) {
        logThemeChanging(selectedTheme: selectedTheme)
    }
}
