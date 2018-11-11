//
//  UIColor.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 06/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import UIKit

extension UIColor {
    static let lightYellow = UIColor(red: 253 / 255, green: 255 / 255, blue: 237 / 255, alpha: 1)
    
    private var rgbComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return (red, green, blue, alpha)
        }
        return (0, 0, 0, 0)
    }
    
    var string: String {
        return String(format: "#%02x%02x%02x", Int(rgbComponents.red * 255), Int(rgbComponents.green * 255), Int(rgbComponents.blue * 255))
    }
}
