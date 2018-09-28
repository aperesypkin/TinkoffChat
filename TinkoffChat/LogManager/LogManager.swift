//
//  LogManager.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 20.09.2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

class LogManager {
    
    static let shared = LogManager()
    
    var isEnabled = true
    
    private var previousAppDelegateLifecycleState: String?
        
    func logAppDelegateLifecycle(_ functionName: String, state: String) {
        guard isEnabled else { return }
        if let previousState = previousAppDelegateLifecycleState {
            print("Application moved from \(previousState) to \(state): \(functionName)")
        } else {
            print("Application moved to \(state): \(functionName)")
        }
        previousAppDelegateLifecycleState = state
    }
    
    func logViewControllerLifecycle(_ functionName: String, className: String) {
        guard isEnabled else { return }
        print("\(className): \(functionName)")
    }
    
}
