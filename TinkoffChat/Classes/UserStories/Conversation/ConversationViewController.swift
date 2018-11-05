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
    var userID: String!
    
    private var dataSource: [ConversationModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        communicationManager.send(message: message, for: userID)
        messageTextField.text = nil
    }
    
    private func setupCommunicationManager() {
        communicationManager.currentUserID = userID
        
        communicationManager.obtainMessages(for: userID) { [weak self] messages in
            guard let messages = messages else { return }
            self?.dataSource = messages.reversed()
        }
        
        communicationManager.didChangeMessagesAction = { [weak self] messages in
            self?.dataSource = messages.reversed()
        }
        
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
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row]
        
        if model.isIncomingMessage {
            let cell: IncomingMessageCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: model.viewModel)
            cell.transform = CGAffineTransform.reverse
            return cell
        } else {
            let cell: OutgoingMessageCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: model.viewModel)
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
