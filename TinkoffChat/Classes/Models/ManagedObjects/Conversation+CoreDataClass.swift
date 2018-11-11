//
//  Conversation+CoreDataClass.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 10/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Conversation)
public class Conversation: NSManagedObject {
    static func fetchRequestConversationsAreNotEmptyWhereUserIsOnline(context: NSManagedObjectContext) -> NSFetchRequest<Conversation>? {
        let model = context.persistentStoreCoordinator?.managedObjectModel
        let request = model?.fetchRequestTemplate(forName: "ConversationsAreNotEmptyWhereUserIsOnline") as? NSFetchRequest<Conversation>
        return request
    }
    
    static func fetchRequestConversations(context: NSManagedObjectContext, identifier: String) -> NSFetchRequest<Conversation>? {
        let model = context.persistentStoreCoordinator?.managedObjectModel
        let request = model?.fetchRequestFromTemplate(withName: "CoversationWithID", substitutionVariables: ["identifier": identifier]) as? NSFetchRequest<Conversation>
        return request
    }
    
    typealias ViewModel = ConversationsListViewController.ViewModel
    
    var viewModel: ViewModel {
        return ViewModel(name: user?.name ?? "Unnamed",
                         message: lastMessage?.text ?? "No messages yet",
                         font: font,
                         date: dateString,
                         backgroundColor: backgroundColor,
                         online: online)
    }
    
    private var font: UIFont {
        if let message = lastMessage {
            return message.isUnread ? UIFont.boldSystemFont(ofSize: UIFont.systemFontSize) : UIFont.systemFont(ofSize: UIFont.systemFontSize)
        } else {
            return UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)
        }
    }
    
    private var dateString: String {
        let dateFormatter = DateFormatter()
        if let date = lastMessage?.date as Date? {
            dateFormatter.dateFormat = date.isToday ? "HH:mm" : "dd MMM"
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }
    
    private var backgroundColor: UIColor {
        if let user = user {
            return user.isOnline ? .lightYellow : .white
        } else {
            return .white
        }
    }
    
    private var online: Bool {
        if let user = user {
            return user.isOnline
        } else {
            return false
        }
    }
}
