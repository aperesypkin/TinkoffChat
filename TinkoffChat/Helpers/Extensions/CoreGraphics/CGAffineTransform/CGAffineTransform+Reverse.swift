//
//  CGAffineTransform+Reverse.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 28/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

extension CGAffineTransform {
    static var reverse: CGAffineTransform {
        return self.init(scaleX: 1, y: -1)
    }
}
