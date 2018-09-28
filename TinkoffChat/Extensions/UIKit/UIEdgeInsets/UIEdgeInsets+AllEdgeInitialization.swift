//
//  UIEdgeInsets+AllEdgeInitialization.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 27/09/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    init(_ value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }
}
