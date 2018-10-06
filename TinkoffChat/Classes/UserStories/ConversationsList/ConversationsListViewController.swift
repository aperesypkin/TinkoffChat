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
        } else {
            super.prepare(for: segue, sender: sender)
        }
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
