//
//  ConversationAnimator.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 02/12/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

class ConversationAnimator {
    
    func animate(button: UIButton, isEnabled: Bool) {
        UIView.animate(withDuration: 0.33, animations: {
            button.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        }, completion: { _ in
            UIView.animate(withDuration: 0.33, delay: 0.5, animations: {
                button.transform = CGAffineTransform.identity
            })
        })
        
        UIView.transition(with: button, duration: 0.33, options: .transitionCrossDissolve, animations: {
            button.isEnabled = isEnabled
        })
    }
    
}
