//
//  UIViewController+Contents.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 06/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import UIKit

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else if let tabcon = self as? UITabBarController {
            return tabcon.selectedViewController ?? self
        } else {
            return self
        }
    }
}
