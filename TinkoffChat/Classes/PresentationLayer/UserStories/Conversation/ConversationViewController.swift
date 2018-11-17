//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 04/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import UIKit
import CoreData

class ConversationViewController: BaseViewController {
    
    struct ViewModel {
        let text: String
    }
    
    @IBOutlet var messageTextField: UITextField! {
        didSet {
            messageTextField.delegate = self
        }
    }
    
    @IBOutlet var sendButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.transform = CGAffineTransform.reverse
            tableView.register(IncomingMessageCell.self)
            tableView.register(OutgoingMessageCell.self)
        }
    }
    
//    private lazy var dataManager: FetchedResultControllerManager<Message> = {
//        let fetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "%K = %@", #keyPath(Message.conversation.identifier), userID)
//
//        let dateSort = NSSortDescriptor(key: #keyPath(Message.date), ascending: false)
//
//        fetchRequest.sortDescriptors = [dateSort]
//
//        return FetchedResultControllerManager(fetchRequest: fetchRequest,
//                                              sectionNameKeyPath: nil,
//                                              cacheName: nil)
//    }()
    
    private let dataManager: IConversationDataManager
    private let isUserOnline: Bool
    private let userID: String
    
    init(dataManager: IConversationDataManager, userID: String, isUserOnline: Bool) {
        self.dataManager = dataManager
        self.userID = userID
        self.isUserOnline = isUserOnline
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        dataManager.performFetch(for: tableView)
        
        sendButton.isEnabled = isUserOnline
        dataManager.performFetchData()
        
        setupKeyboardNotifications()
//        setupCommunicationManager()
        setupTapGesture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dataManager.markMessagesAsRead(for: userID)
    }
    
    @IBAction func didTapSendButton(_ sender: UIButton) {
        guard let message = messageTextField.text,
            !message.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
                messageTextField.text = nil
                return
        }
        
//        communicationManager.send(text: message, for: userID)
        dataManager.send(text: message, for: userID)
        messageTextField.text = nil
    }
    
    private func setupCommunicationManager() {
//        communicationManager.didOpenConversation(with: userID)
//
//        communicationManager.currentUserStatus = { [weak self] isOnline in
//            self?.sendButton.isEnabled = isOnline
//        }
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ConversationViewController.didTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTap() {
        view.endEditing(true)
    }
    
}

// MARK: - UITableViewDataSource
extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.numberOfObjects(at: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let message = dataManager.object(at: indexPath) else { return UITableViewCell() }

        if message.isIncomingMessage {
            let cell: IncomingMessageCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: message.viewModel)
            cell.transform = CGAffineTransform.reverse
            return cell
        } else {
            let cell: OutgoingMessageCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: message.viewModel)
            cell.transform = CGAffineTransform.reverse
            return cell
        }
    }
}

// MARK: - UITextFieldDelegate
extension ConversationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ConversationViewController: IConversationDataManagerDelegate {
    func didChange(user: String, online status: Bool) {
        sendButton.isEnabled = status
    }
    
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
    
}
