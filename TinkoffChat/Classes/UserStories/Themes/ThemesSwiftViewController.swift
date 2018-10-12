//
//  ThemesSwiftViewController.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 11/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import UIKit

class ThemesSwiftViewController: UIViewController {
    
    private let themes = [Themes().theme1, Themes().theme2, Themes().theme3]
    
    var themeButtonAction: ((UIColor) -> Void)?

    @IBAction func didTapCloseButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapThemeButton(_ sender: UIButton) {
        if let color = themes[sender.tag] {
            view.backgroundColor = color
            themeButtonAction?(color)
        }
    }
    
}
