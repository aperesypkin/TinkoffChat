//
//  RootAssembly.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 15/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation

class RootAssembly {
    lazy var presentationAssembly: IPresentationAssembly = PresentationAssembly(serviceAssembly: self.serviceAssembly)
    private lazy var serviceAssembly: IServicesAssembly = ServicesAssembly(coreAssembly: self.coreAssembly)
    private lazy var coreAssembly: ICoreAssembly = CoreAssembly()
}
