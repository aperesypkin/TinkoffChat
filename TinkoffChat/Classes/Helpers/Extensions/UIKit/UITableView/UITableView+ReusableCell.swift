//
//  UITableView+ReusableCell.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 05/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import UIKit

extension UITableView {    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError()
        }
        return cell
    }
}
