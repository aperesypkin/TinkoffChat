//
//  ThemeListViewController.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 11/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import UIKit

class ThemeListViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let themesColor = [Themes().theme1, Themes().theme2, Themes().theme3]
    
    // MARK: - Dependencies
    
    private let dataManager: IThemeListDataManager
    
    // MARK: - Initialization
    
    init(dataManager: IThemeListDataManager) {
        self.dataManager = dataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCloseBarButton()
    }
    
    // MARK: - Private methods
    
    private func setupCloseBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(didTapCloseButton))
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true)
    }
    
    // MARK: - IB Actions
    
    @IBAction func didTapThemeButton(_ sender: UIButton) {
        if let color = themesColor[sender.tag] {
            view.backgroundColor = color
            dataManager.save(color: color)
        }
    }
    
}
