//
//  ICommunicator.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 17/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

protocol ICommunicator {
    var delegate: ICommunicatorDelegate? { get set }
    func sendMessage(string: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> Void)?)
    func start()
}
