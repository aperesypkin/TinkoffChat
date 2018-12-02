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
    
    // MARK: - UI
    
    let titleLabel = UILabel()
    
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
    
    // MARK: - Dependencies
    
    private let dataManager: IConversationDataManager
    
    // MARK: - Private properties
    
    private var isUserOnline: Bool
    private let userID: String
    
    private let animator = ConversationAnimator()
    
    private var isSendButtonAvailable: Bool = false {
        didSet {
            if oldValue != isSendButtonAvailable {
                animator.animate(button: sendButton, isEnabled: isSendButtonAvailable)
            }
        }
    }
    
    // MARK: - Initialization
    
    init(dataManager: IConversationDataManager, userID: String, isUserOnline: Bool) {
        self.dataManager = dataManager
        self.userID = userID
        self.isUserOnline = isUserOnline
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
        
        changeTitleLabel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        dataManager.markMessagesAsRead(for: userID)
    }
    
    // MARK: - IB Actions
    
    @IBAction func didTapSendButton(_ sender: UIButton) {
        guard let message = messageTextField.text,
            !message.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
                messageTextField.text = nil
                changeSendButtonStatusIfNeeded()
                return
        }
        
        dataManager.send(text: message, for: userID)
        messageTextField.text = nil
        changeSendButtonStatusIfNeeded()
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        changeSendButtonStatusIfNeeded()
    }
    
    // MARK: - Private methods
    
    private func setup() {
        sendButton.isEnabled = false
        setupKeyboardNotifications()
        setupTapGesture()
        setupTitleLabel()
    }
    
    private func setupTitleLabel() {
        titleLabel.sizeToFit()
        titleLabel.frame.size.width *= 1.3
        titleLabel.textAlignment = .center
        navigationItem.titleView = titleLabel
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ConversationViewController.didTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTap() {
        view.endEditing(true)
    }
    
    private func changeSendButtonStatusIfNeeded() {
        if (messageTextField.text ?? "").isEmpty || isUserOnline == false {
            isSendButtonAvailable = false
        } else {
            isSendButtonAvailable = true
        }
    }
    
    private func changeTitleLabel() {
        guard let label = navigationItem.titleView as? UILabel else { return }
        animator.animate(label: label, isUserOnline: isUserOnline)
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

// MARK: - IConversationDataManagerDelegate
extension ConversationViewController: IConversationDataManagerDelegate {
    func didChange(user: String, online status: Bool) {
        isUserOnline = status
        changeSendButtonStatusIfNeeded()
        changeTitleLabel()
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
