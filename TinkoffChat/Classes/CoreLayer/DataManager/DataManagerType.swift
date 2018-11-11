//
//  DataManagerType.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 20/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

enum DataManagerType {
    case gcd
    case operation
    
    func dataManager() -> DataManager {
        switch self {
        case .gcd: return GCDDataManager()
        case .operation: return OperationDataManager()
        }
    }
}
