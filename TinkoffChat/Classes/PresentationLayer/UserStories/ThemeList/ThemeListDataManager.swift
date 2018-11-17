//
//  ThemeListDataManager.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 18/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import UIKit

protocol IThemeListDataManager {
    func save(color: UIColor)
}

class ThemeListDataManager: IThemeListDataManager {
    
    private let themes = [UIColor.black: Theme.black,
                          UIColor.blue: Theme.blue,
                          UIColor.white: Theme.white]
    
    private let themeService: IThemeService
    
    init(themeService: IThemeService) {
        self.themeService = themeService
    }
    
    func save(color: UIColor) {
        if let theme = themes[color] {
            theme.apply()
            themeService.save(theme: theme)
        }
    }
}
