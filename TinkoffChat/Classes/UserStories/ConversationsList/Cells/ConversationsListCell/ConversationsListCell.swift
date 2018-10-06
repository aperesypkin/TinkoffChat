//
//  ConversationsListTableViewCell.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 04/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import UIKit

class ConversationsListCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configure(with model: ConversationsListViewController.ViewModel) {
        nameLabel.text = model.name
        lastMessageLabel.text = model.message
        lastMessageLabel.font = model.font.withSize(lastMessageLabel.font.pointSize)
        dateLabel.text = model.date
        backgroundColor = model.backgroundColor
    }
    
}
