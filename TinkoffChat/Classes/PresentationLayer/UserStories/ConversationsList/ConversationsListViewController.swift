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
    
    // MARK: - UI
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.register(ConversationsListCell.self)
        }
    }
    
    // MARK: - Dependencies
    
    private let dataManager: IConversationsListDataManager
    private let presentationAssembly: IPresentationAssembly
    
    // MARK: - Initialization
    
    init(dataManager: IConversationsListDataManager, presentationAssembly: IPresentationAssembly) {
        self.dataManager = dataManager
        self.presentationAssembly = presentationAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        dataManager.performFetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Private methods
    
    private func setup() {
        title = "TinkoffChat"
        setupBarButtons()
    }
    
    private func setupBarButtons() {
        setupProfileBarButton()
        setupThemeListBarButton()
    }
    
    private func setupProfileBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Профиль", style: .plain, target: self, action: #selector(didTapProfileButton))
    }
    
    @objc private func didTapProfileButton() {
        let profileViewController = presentationAssembly.profileViewController()
        let navigationController = UINavigationController(rootViewController: profileViewController)
        present(navigationController, animated: true)
    }
    
    private func setupThemeListBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Темы", style: .plain, target: self, action: #selector(didTapThemeListButton))
    }
    
    @objc private func didTapThemeListButton() {
        let profileViewController = presentationAssembly.themeListViewController()
        let navigationController = UINavigationController(rootViewController: profileViewController)
        present(navigationController, animated: true)
    }

}

// MARK: - UITableViewDataSource
extension ConversationsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataManager.sectionsCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.numberOfObjects(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let conversation = dataManager.object(at: indexPath) else { return UITableViewCell() }
        
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
        
        if let userID = conversation?.user?.identifier, let isOnline = conversation?.user?.isOnline {
            let conversationViewController = presentationAssembly.conversationViewController(userID: userID, isUserOnline: isOnline)
            conversationViewController.titleLabel.text = conversation?.user?.name
            navigationController?.pushViewController(conversationViewController, animated: true)
        }
    }
}

// MARK: - IConversationsListDataManagerDelegate
extension ConversationsListViewController: IConversationsListDataManagerDelegate {
    func dataWillChange() {
        tableView.beginUpdates()
    }
    
    func dataDidChange() {
        tableView.endUpdates()
    }
    
    func objectDidChange(at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert: tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete: tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update: tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        }
    }
    
    func sectionDidChange(atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)

        switch type {
        case .insert: tableView.insertSections(indexSet, with: .automatic)
        case .delete: tableView.deleteSections(indexSet, with: .automatic)
        default: break
        }
    }
}
