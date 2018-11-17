//
//  CommonThemeService.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 18/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

class CommonThemeService: IThemeService {
    
    private struct Keys {
        static let selectedTheme = "SelectedTheme"
    }
    
    private struct State: Codable {
        var rawValue: String?
    }
    
    private let dataManager: IDataManager
    
    private var state = State()
    
    init(dataManager: IDataManager) {
        self.dataManager = dataManager
    }
    
    func save(theme: Theme) {
        state.rawValue = theme.rawValue
        dataManager.save(state, to: Keys.selectedTheme) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func loadTheme(completionHandler: @escaping (Theme?) -> Void) {
        dataManager.load(State.self, from: Keys.selectedTheme) { state, _ in
            if let state = state, let rawValue = state.rawValue {
                completionHandler(Theme(rawValue: rawValue))
            } else {
                completionHandler(nil)
            }
        }
    }
    
}
