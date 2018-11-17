//
//  IThemeService.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 18/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

protocol IThemeService {
    func save(theme: Theme)
    func loadTheme(completionHandler: @escaping (Theme?) -> Void)
}
