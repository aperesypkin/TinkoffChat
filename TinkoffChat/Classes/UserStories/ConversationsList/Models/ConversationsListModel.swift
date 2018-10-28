//
//  CConversationsListModel.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 25/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

struct ConversationsListModel {
    let id: String
    let name: String?
    var message: String?
    var date: Date?
    let online: Bool
    var hasUnreadMessages: Bool
}

extension ConversationsListModel {
    typealias ViewModel = ConversationsListViewController.ViewModel
    
    var viewModel: ViewModel {
        return ViewModel(name: name ?? "Unnamed",
                         message: message ?? "No messages yet",
                         font: font,
                         date: dateString,
                         backgroundColor: online ? .lightYellow : .white,
                         online: online)
    }
    
    private var font: UIFont {
        if message != nil {
            return hasUnreadMessages ? UIFont.boldSystemFont(ofSize: UIFont.systemFontSize) : UIFont.systemFont(ofSize: UIFont.systemFontSize)
        } else {
            return UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)
        }
    }
    
    private var dateString: String {
        let dateFormatter = DateFormatter()
        if let date = date {
            dateFormatter.dateFormat = date.isToday ? "HH:mm" : "dd MMM"
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }
}
