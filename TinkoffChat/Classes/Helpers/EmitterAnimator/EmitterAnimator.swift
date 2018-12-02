//
//  EmitterAnimator.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 02/12/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

class EmitterAnimator {
    
    private struct Constants {
        static let emitterCellBirthRate: Float = 10
        static let emitterCellLifetime: Float = 1
        static let emitterCellVelocity: CGFloat = 100
        static let emitterCellScale: CGFloat = 0.1
        static let emitterCellEmissionRange: CGFloat = CGFloat.pi * 2.0
        
        static let emitterEnabledLifetime: Float = 1
        static let emitterDisabledLifetime: Float = 0
    }
    
    private let window: UIWindow
    
    private lazy var emitterLayer: CAEmitterLayer = {
        let emitter = CAEmitterLayer()
        emitter.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        emitter.renderMode = .oldestFirst
        emitter.emitterShape = .rectangle
        emitter.lifetime = Constants.emitterDisabledLifetime
        emitter.emitterCells = [emitterСell]
        return emitter
    }()
    
    private lazy var emitterСell: CAEmitterCell = {
        let cell = CAEmitterCell()
        cell.birthRate = Constants.emitterCellBirthRate
        cell.lifetime = Constants.emitterCellLifetime
        cell.velocity = Constants.emitterCellVelocity
        cell.scale = Constants.emitterCellScale
        cell.emissionRange = Constants.emitterCellEmissionRange
        cell.contents = #imageLiteral(resourceName: "logo").cgImage
        return cell
    }()
    
    init(window: UIWindow) {
        self.window = window
        self.window.layer.addSublayer(emitterLayer)
    }
    
    func startAnimation(on position: CGPoint) {
        emitterLayer.lifetime = Constants.emitterEnabledLifetime
        emitterLayer.emitterPosition = position
    }
    
    func moveAnimation(on position: CGPoint) {
        emitterLayer.emitterPosition = position
    }
    
    func stopAnimation() {
        emitterLayer.lifetime = Constants.emitterDisabledLifetime
    }
    
}
