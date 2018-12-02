//
//  TCWindow.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 02/12/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

class TCWindow: UIWindow {
    
    private var emitterAnimator: EmitterAnimator?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        emitterAnimator = EmitterAnimator(window: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        
        guard let touches = event.allTouches, let touch = touches.first else { return }
        
        switch touch.phase {
        case .began: emitterAnimator?.startAnimation(on: touch.location(in: self))
        case .moved: emitterAnimator?.moveAnimation(on: touch.location(in: self))
        case .ended, .cancelled: emitterAnimator?.stopAnimation()
        default: break
        }
    }
}
