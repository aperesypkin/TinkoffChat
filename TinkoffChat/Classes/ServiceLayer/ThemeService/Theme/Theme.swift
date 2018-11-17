//
//  Theme.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 13/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import UIKit

enum Theme: String {
    case black, blue, white
    
    var tintColor: UIColor {
        switch self {
        case .black: return .white
        case .blue: return .white
        case .white: return .blue
        }
    }
    
    var barTintColor: UIColor {
        switch self {
        case .black: return .black
        case .blue: return .blue
        case .white: return .white
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .black: return .white
        case .blue: return .white
        case .white: return .black
        }
    }
    
    func apply() {
        let appearance = UINavigationBar.appearance()
        appearance.tintColor = tintColor
        appearance.barTintColor = barTintColor
        appearance.titleTextAttributes = [.foregroundColor: titleColor]
        
        let windows = UIApplication.shared.windows as [UIWindow]
        for window in windows {
            let subviews = window.subviews as [UIView]
            for view in subviews {
                view.removeFromSuperview()
                window.addSubview(view)
            }
        }
    }
}
