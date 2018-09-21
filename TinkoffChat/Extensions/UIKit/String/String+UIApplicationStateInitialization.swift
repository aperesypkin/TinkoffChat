//
//  String+UIApplicationStateInitialization.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 21.09.2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import UIKit

extension String {
    init(_ state: UIApplication.State) {
        switch state {
        case .active: self = "Active"
        case .background: self = "Background"
        case .inactive: self = "Inactive"
        }
    }
}
