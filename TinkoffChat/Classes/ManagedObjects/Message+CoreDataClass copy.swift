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
    typealias ViewModel = ConversationViewController.ViewModel
    
    var viewModel: ViewModel {
        return ViewModel(text: text ?? "")
    }
}
