//
//  Message+CoreDataClass.swift
//  
//
//  Created by Alexander Peresypkin on 10/11/2018.
//
//

import Foundation
import CoreData

@objc(Message)
public class Message: NSManagedObject {
    static func fetchRequestMessages(context: NSManagedObjectContext, conversationID: String) -> NSFetchRequest<Message>? {
        let model = context.persistentStoreCoordinator?.managedObjectModel
        let request = model?.fetchRequestFromTemplate(withName: "MessagesForConversationID", substitutionVariables: ["identifier": conversationID]) as? NSFetchRequest<Message>
        return request
    }
    
    typealias ViewModel = ConversationViewController.ViewModel
    
    var viewModel: ViewModel {
        return ViewModel(text: text ?? "")
    }
}
