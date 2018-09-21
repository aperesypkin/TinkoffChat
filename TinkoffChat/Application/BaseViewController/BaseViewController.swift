//
//  BaseViewController.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 21.09.2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    private var className: String {
        return String(describing: type(of: self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        LogManager.shared.loggingViewControllerLifecycle(#function, className: className)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        LogManager.shared.loggingViewControllerLifecycle(#function, className: className)
    }
    
    override func loadView() {
        super.loadView()
        LogManager.shared.loggingViewControllerLifecycle(#function, className: className)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.shared.loggingViewControllerLifecycle(#function, className: className)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LogManager.shared.loggingViewControllerLifecycle(#function, className: className)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogManager.shared.loggingViewControllerLifecycle(#function, className: className)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        LogManager.shared.loggingViewControllerLifecycle(#function, className: className)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        LogManager.shared.loggingViewControllerLifecycle(#function, className: className)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LogManager.shared.loggingViewControllerLifecycle(#function, className: className)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        LogManager.shared.loggingViewControllerLifecycle(#function, className: className)
    }

}
