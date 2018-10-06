//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 04/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import UIKit

class ConversationViewController: BaseViewController {
    
    struct ViewModel {
        let message: String
        let isIncomingMessage: Bool
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
            tableView.register(IncomingMessageCell.self)
            tableView.register(OutgoingMessageCell.self)
        }
    }
    
    private var dataSource: [ViewModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = fakeData
    }
    
    // Потом удалить
    private let fakeData: [ViewModel] = [ViewModel(message: "Текст входящего сообщения", isIncomingMessage: true),
                                         ViewModel(message: "Текст исходящего сообщения", isIncomingMessage: false),
                                         ViewModel(message: "12345", isIncomingMessage: true),
                                         ViewModel(message: "Очень много много много много много много много входящего текста", isIncomingMessage: true),
                                         ViewModel(message: "Очень много много много много много много много исходящего текста", isIncomingMessage: false),
                                         ViewModel(message: "Текст входящего сообщения qwerty", isIncomingMessage: true),
                                         ViewModel(message: "Текст входящего сообщения", isIncomingMessage: true),
                                         ViewModel(message: "Текст исходящего сообщения", isIncomingMessage: false),
                                         ViewModel(message: "12345", isIncomingMessage: true),
                                         ViewModel(message: "Очень много много много много много много много входящего текста", isIncomingMessage: true),
                                         ViewModel(message: "Очень много много много много много много много исходящего текста", isIncomingMessage: false),
                                         ViewModel(message: "Текст входящего сообщения qwerty", isIncomingMessage: true),
                                         ViewModel(message: "Текст входящего сообщения", isIncomingMessage: true),
                                         ViewModel(message: "Текст исходящего сообщения", isIncomingMessage: false),
                                         ViewModel(message: "12345", isIncomingMessage: true),
                                         ViewModel(message: "Очень много много много много много много много входящего текста", isIncomingMessage: true),
                                         ViewModel(message: "Очень много много много много много много много исходящего текста", isIncomingMessage: false),
                                         ViewModel(message: "Текст входящего сообщения qwerty", isIncomingMessage: true)]

}

// MARK: - UITableViewDataSource
extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row]
        
        if model.isIncomingMessage {
            let cell: IncomingMessageCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: model)
            return cell
        } else {
            let cell: OutgoingMessageCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: model)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension ConversationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
