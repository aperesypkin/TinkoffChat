//
//  UICollectionView+RegisterCell.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 23/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(_ type: T.Type) {
        let cellName = String(describing: T.self)
        
        if Bundle.main.path(forResource: cellName, ofType: "nib") != nil {
            let nib = UINib(nibName: cellName, bundle: nil)
            register(nib, forCellWithReuseIdentifier: cellName)
        } else {
            register(T.self, forCellWithReuseIdentifier: cellName)
        }
    }
}
