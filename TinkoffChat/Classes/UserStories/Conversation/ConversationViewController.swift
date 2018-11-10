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
    
    var communicationManager: CommunicationManager!
    var user: User!
    
//    private var dataSource: [ConversationModel] = [] {
//        didSet {
//            tableView.reloadData()
//        }
//    }
    
    private lazy var fetchedResultController: NSFetchedResultsController<Message> = {
        let fetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
        if let identifier = user.identifier {
            fetchRequest.predicate = NSPredicate(format: "%K = %@", #keyPath(Message.conversation.identifier), identifier)
        }
        
        let dateSort = NSSortDescriptor(key: #keyPath(Message.date), ascending: false)
        
        fetchRequest.sortDescriptors = [dateSort]
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                 managedObjectContext: CoreDataStack.shared.mainContext,
                                                                 sectionNameKeyPath: nil,
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
        
        sendButton.isEnabled = user.isOnline
        
        setupKeyboardNotifications()
        setupCommunicationManager()
        setupTapGesture()
    }
    
    @IBAction func didTapSendButton(_ sender: UIButton) {
        guard let message = messageTextField.text,
            !message.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
                messageTextField.text = nil
                return
        }
        
        if let identifier = user.identifier {
            communicationManager.send(text: message, for: identifier)
        }
        
        messageTextField.text = nil
    }
    
    private func setupCommunicationManager() {
        if let identifier = user.identifier {
            communicationManager.currentUserID = identifier
        }
        
//        communicationManager.obtainMessages(for: userID) { [weak self] messages in
//            guard let messages = messages else { return }
//            self?.dataSource = messages.reversed()
//        }
//        
//        communicationManager.didChangeMessagesAction = { [weak self] messages in
//            self?.dataSource = messages.reversed()
//        }
//        
        communicationManager.currentUserStatus = { [weak self] isOnline in
            self?.sendButton.isEnabled = isOnline
        }
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ConversationViewController.didTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTap() {
        view.endEditing(true)
    }
    
    deinit {
        communicationManager.currentUserID = nil
    }
    
}

// MARK: - UITableViewDataSource
extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = fetchedResultController.object(at: indexPath)
        
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

extension ConversationViewController: NSFetchedResultsControllerDelegate {
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
}
