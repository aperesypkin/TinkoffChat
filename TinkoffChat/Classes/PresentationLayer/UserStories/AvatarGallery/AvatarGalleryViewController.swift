//
//  AvatarGalleryViewController.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 23/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import UIKit

protocol IAvatarGalleryViewControllerDelegate: class {
    func didChoose(image: UIImage)
}

class AvatarGalleryViewController: UIViewController {
    
    weak var delegate: IAvatarGalleryViewControllerDelegate?
    
    private var dataSource: [AvatarGalleryViewModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - UI
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(AvatarCell.self)
        }
    }
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Dependencies
    
    private let dataManager: IAvatarGalleryDataManager
    
    // MARK: - Initialization
    
    init(dataManager: IAvatarGalleryDataManager) {
        self.dataManager = dataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        fetchData()
    }
    
    // MARK: - Private methods
    
    private func setup() {
        title = "Выберите аватарку"
        setupCloseBarButtonItem()
    }
    
    private func setupCloseBarButtonItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Закрыть",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapCloseButton))
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true)
    }
    
    private func fetchData() {
        activityIndicator.startAnimating()
        dataManager.fetchImages { [weak self] viewModels in
            if let viewModels = viewModels {
                self?.dataSource = viewModels
            }
            self?.activityIndicator.stopAnimating()
        }
    }
    
}

// MARK: - UICollectionViewDataSource
extension AvatarGalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataSource[indexPath.row]
        
        let cell: AvatarCell = collectionView.dequeueReusableCell(for: indexPath)
        configure(cell: cell, with: model)
        return cell
    }
    
    private func configure(cell: AvatarCell, with model: AvatarGalleryViewModel) {
        cell.avatarImageView.image = #imageLiteral(resourceName: "placeholder-user")
        cell.activityIndicator.startAnimating()
        cell.imageURL = model.imageURL
        dataManager.fetchImage(url: model.imageURL) { image in
            if let image = image, cell.imageURL == model.imageURL {
                cell.avatarImageView.image = image
                cell.activityIndicator.stopAnimating()
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension AvatarGalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? AvatarCell, let image = cell.avatarImageView.image, image != #imageLiteral(resourceName: "placeholder-user") {
            delegate?.didChoose(image: image)
            dismiss(animated: true)
        }
    }
}
