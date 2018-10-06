//
//  OutgoingMessageCell.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 06/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import UIKit

class OutgoingMessageCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    
    func configure(with model: ConversationViewController.ViewModel) {
        messageLabel.text = model.message
    }
    
}
