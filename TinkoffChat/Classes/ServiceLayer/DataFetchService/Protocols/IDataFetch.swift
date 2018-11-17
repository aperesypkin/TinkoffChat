//
//  IDataFetch.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 17/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import CoreData

protocol IDataFetch {
    var delegate: IDataFetchDelegate? { get set }
    
    func performFetch()
    func sectionsCount() -> Int
    func numberOfObjects(at section: Int) -> Int
    func object(at indexPath: IndexPath) -> NSFetchRequestResult
    func name(for section: Int) -> String?
}
