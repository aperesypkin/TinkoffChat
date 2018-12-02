//
//  EmitterAnimator.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 02/12/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

class EmitterAnimator {
    
    private let window: UIWindow
    
    private lazy var emitterLayer: CAEmitterLayer = {
        let emitter = CAEmitterLayer()
        emitter.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        emitter.renderMode = .oldestFirst
        emitter.emitterShape = .rectangle
        emitter.lifetime = 0
        emitter.emitterCells = [emitterСell]
        return emitter
    }()
    
    private lazy var emitterСell: CAEmitterCell = {
        let cell = CAEmitterCell()
        cell.birthRate = 10
        cell.lifetime = 1
        cell.velocity = 100
        cell.scale = 0.1
        
        cell.emissionRange = CGFloat.pi * 2.0
        cell.contents = #imageLiteral(resourceName: "logo").cgImage
        
        return cell
    }()
    
    init(window: UIWindow) {
        self.window = window
        self.window.layer.addSublayer(emitterLayer)
    }
    
    func startAnimation(on position: CGPoint) {
        emitterLayer.lifetime = 1
        emitterLayer.emitterPosition = position
    }
    
    func moveAnimation(on position: CGPoint) {
        emitterLayer.emitterPosition = position
    }
    
    func stopAnimation() {
        emitterLayer.lifetime = 0
    }
    
}
