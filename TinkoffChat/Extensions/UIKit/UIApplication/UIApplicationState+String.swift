//
//  UIApplicationState+String.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 28/09/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import UIKit

extension UIApplication.State {
    var string: String {
        switch self {
        case .active: return "Active"
        case .background: return "Background"
        case .inactive: return "Inactive"
        }
    }
}
