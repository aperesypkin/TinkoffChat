//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 03/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import UIKit

private struct Identifiers {
    static let conversationSequeIdentifier = "ConversationSequeIdentifier"
    static let themesSequeIdentifier = "ThemesSequeIdentifier"
    static let themesSwiftSequeIdentifier = "ThemesSwiftSequeIdentifier"
}

final class ConversationsListViewController: BaseViewController {
    
    enum SectionType {
        case online
        case history
        
        var title: String {
            switch self {
            case .history: return "History"
            case .online: return "Online"
            }
        }
    }
    
    struct Section {
        let sectionType: SectionType
        let items: [ViewModel]
    }
    
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
    
    private var dataSource: [Section] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    private let dataManager = ConversationsListDataManager()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.obtainConversationsList { viewModels in
            dataSource = viewModels
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.conversationSequeIdentifier {
            if let conversationViewController = segue.destination.contents as? ConversationViewController {
                conversationViewController.title = (sender as? ConversationsListCell)?.nameLabel.text
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
        Theme.current = themes[selectedTheme]
        Theme.current?.apply()
    }

}

// MARK: - UITableViewDataSource
extension ConversationsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.section].items[indexPath.row]
        
        let cell: ConversationsListCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].sectionType.title
    }
}

// MARK: - UITableViewDelegate
extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: Identifiers.conversationSequeIdentifier, sender: tableView.cellForRow(at: indexPath))
    }
}

// MARK: - ​ThemesViewControllerDelegate
extension ConversationsListViewController: ​ThemesViewControllerDelegate {
    func themesViewController(_ controller: ThemesViewController, didSelectTheme selectedTheme: UIColor) {
        logThemeChanging(selectedTheme: selectedTheme)
    }
}