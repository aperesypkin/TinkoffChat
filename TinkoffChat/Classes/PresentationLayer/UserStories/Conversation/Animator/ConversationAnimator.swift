//
//  ConversationAnimator.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 02/12/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

class ConversationAnimator {
    
    private struct Constants {
        static let buttonAnimateDuration: TimeInterval = 0.33
        static let buttonAnimateDelay: TimeInterval = 0.5
        static let buttonScale: CGFloat = 1.15
        
        static let labelAnimateDuration: TimeInterval = 1
        static let labelScale: CGFloat = 1.1
    }
    
    func animate(button: UIButton, isEnabled: Bool) {
        UIView.animate(withDuration: Constants.buttonAnimateDuration, animations: {
            button.transform = CGAffineTransform(scaleX: Constants.buttonScale, y: Constants.buttonScale)
        }, completion: { _ in
            UIView.animate(withDuration: Constants.buttonAnimateDuration, delay: Constants.buttonAnimateDelay, animations: {
                button.transform = CGAffineTransform.identity
            })
        })
        
        UIView.transition(with: button, duration: Constants.buttonAnimateDuration, options: .transitionCrossDissolve, animations: {
            button.isEnabled = isEnabled
        })
    }
    
    func animate(label: UILabel, isUserOnline: Bool) {
        UIView.transition(with: label, duration: Constants.labelAnimateDuration, options: .transitionCrossDissolve, animations: {
            label.transform = isUserOnline ? CGAffineTransform(scaleX: Constants.labelScale, y: Constants.labelScale) : .identity
            label.textColor = isUserOnline ? .green : .black
        })
    }
    
}
