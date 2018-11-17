//
//  ThemeListViewController.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 11/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import UIKit

class ThemeListViewController: UIViewController {
    
    private let themesColor = [Themes().theme1, Themes().theme2, Themes().theme3]
    
    private let dataManager: IThemeListDataManager
    
    init(dataManager: IThemeListDataManager) {
        self.dataManager = dataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCloseBarButton()
    }
    
    func setupCloseBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(didTapCloseButton))
    }
    
    @objc func didTapCloseButton() {
        dismiss(animated: true)
    }
    
    @IBAction func didTapThemeButton(_ sender: UIButton) {
        if let color = themesColor[sender.tag] {
            view.backgroundColor = color
            dataManager.save(color: color)
        }
    }
    
}
