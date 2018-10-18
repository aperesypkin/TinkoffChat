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
    
    private enum Keys {
        static let selectedTheme = "SelectedTheme"
    }
    
    static var current: Theme? {
        get {
            guard let rawValue = UserDefaults.standard.string(forKey: Keys.selectedTheme) else { return nil }
            return Theme(rawValue: rawValue)
        }
        set {
            guard let rawValue = newValue?.rawValue else { return }
            UserDefaults.standard.set(rawValue, forKey: Keys.selectedTheme)
        }
    }
    
    func apply() {
        let appearance = UINavigationBar.appearance()
        appearance.tintColor = tintColor
        appearance.barTintColor = barTintColor
        appearance.titleTextAttributes = [.foregroundColor: titleColor]
    }
}
