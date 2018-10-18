//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 20.09.2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import UIKit

private extension CGFloat {
    static let choosePhotoButtonEdgeInsets: CGFloat = 15
}

class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var editButton: TCButton!
    @IBOutlet var multithreadingButtonsStack: UIStackView!
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet weak var choosePhotoButton: UIButton!
    
    private var isEditMode: Bool = false {
        didSet {
            editButton.isHidden = isEditMode
            nameLabel.isHidden = isEditMode
            
            multithreadingButtonsStack.isHidden = !isEditMode
            nameTextField.isHidden = !isEditMode
        }
    }
    
    private let imagePicker = UIImagePickerController()
    
    private lazy var actionSheetController: UIAlertController = {
        let actionSheetController = UIAlertController(title: "Выберите изображение профиля", message: nil, preferredStyle: .actionSheet)
        
        let chooseFromGalleryAction = UIAlertAction(title: "Установить из галлереи", style: .default) { [weak self] _ in
            guard let `self` = self else { return }
            
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true)
        }
        
        let takePhotoAction = UIAlertAction(title: "Сделать фото", style: .default) { [weak self] _ in
            guard let `self` = self else { return }
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true)
            } else {
                let alert = UIAlertController(title: "Ошибка", message: "Камера не доступна", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert, animated: true)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        actionSheetController.addAction(chooseFromGalleryAction)
        actionSheetController.addAction(takePhotoAction)
        actionSheetController.addAction(cancelAction)
        
        return actionSheetController
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //Fatal error: Unexpectedly found nil while unwrapping an Optional value
        //Получаем краш, так как в этом методе editButton все еще равен nil,
        //а мы пытаемся получить доступ к анврапнотому значению
        //print(editButton.frame)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Получаем фрейм кнопки из сториборда, по этому при запуске на устройстве
        //отличном от устройства в сториборде получаем разный фрейм
        print(editButton.frame)
        
        imagePicker.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Констрейнты уже расчитались и мы получаем верный фрейм у кнопки для
        //устройства на котором запускается приложение
        print(editButton.frame)
    }
    
    @IBAction func didTapCloseButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapChoosePhotoButton(_ sender: UIButton) {
        present(actionSheetController, animated: true)
    }
    
    @IBAction func didTapEditButton(_ sender: TCButton) {
        isEditMode.toggle()
    }
    
    @IBAction func didTapGCDButton(_ sender: TCButton) {
        isEditMode.toggle()
    }
    
    @IBAction func didTapOperationButton(_ sender: TCButton) {
        isEditMode.toggle()
    }
    
    private func setupUI() {
        choosePhotoButton.layer.cornerRadius = choosePhotoButton.bounds.height / 2
        choosePhotoButton.imageEdgeInsets = UIEdgeInsets(all: .choosePhotoButtonEdgeInsets)
        
        photoImageView.layer.masksToBounds = true
        photoImageView.layer.cornerRadius = choosePhotoButton.bounds.height / 2
    }

}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        photoImageView.image = image
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
