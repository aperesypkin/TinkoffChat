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
    
    @IBOutlet var saveButton: TCButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aboutMeTextView: UITextView! {
        didSet {
            aboutMeTextView.delegate = self
        }
    }
    @IBOutlet weak var aboutMeLabel: UILabel!
    @IBOutlet weak var aboutMeContainer: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            nameTextField.delegate = self
        }
    }
    @IBOutlet weak var choosePhotoButton: UIButton!
    
    private var isEditMode: Bool = false {
        didSet {
            editButton.isHidden = isEditMode
            nameLabel.isHidden = isEditMode
            aboutMeContainer.isHidden = isEditMode
            
            saveButton.isHidden = !isEditMode
            nameTextField.isHidden = !isEditMode
            aboutMeTextView.isHidden = !isEditMode
            
            choosePhotoButton.isHidden.toggle()
        }
    }
    
    private let dataManager = ProfileDataManager()
    
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
    
    private lazy var successfulAlert: UIAlertController = {
        let alert = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК", style: .default) { [weak self] _ in
            guard let `self` = self else { return }
            self.loadData()
            self.isEditMode.toggle()
        }
        alert.addAction(action)
        return alert
    }()
    
    private lazy var failureAlert: UIAlertController = {
        let alert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default)
        let repeatAction = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            guard let `self` = self else { return }
            self.saveData()
        }
        alert.addAction(okAction)
        alert.addAction(repeatAction)
        return alert
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardNotifications()
        imagePicker.delegate = self
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateUI()
    }
    
    @IBAction func didTapCloseButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapChoosePhotoButton(_ sender: UIButton) {
        present(actionSheetController, animated: true)
    }
    
    @IBAction func didTapEditButton(_ sender: TCButton) {
        isEditMode.toggle()
        saveButton.isEnabled = false
    }
    
    @IBAction func didTapSaveButton(_ sender: TCButton) {
        view.endEditing(true)
        saveData()
    }
    
    private func saveData() {
        activityIndicator.startAnimating()
        saveButton.isEnabled = false
        dataManager.saveProfile { [weak self] isSuccess, _ in
            guard let `self` = self else { return }
            
            self.saveButton.isEnabled = true
            self.activityIndicator.stopAnimating()
            if isSuccess {
                self.present(self.successfulAlert, animated: true)
            } else {
                self.present(self.failureAlert, animated: true)
            }
        }
    }
    
    private func loadData() {
        activityIndicator.startAnimating()
        saveButton.isEnabled = false
        dataManager.loadProfile { [weak self] profile, _ in
            guard let `self` = self else { return }
            
            self.activityIndicator.stopAnimating()
            if let profile = profile {
                self.nameLabel.text = profile.name
                self.nameTextField.text = profile.name
                self.aboutMeLabel.text = profile.aboutMe
                self.aboutMeTextView.text = profile.aboutMe
                if let imageData = profile.imageData {
                    self.photoImageView.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    private func updateUI() {
        choosePhotoButton.layer.cornerRadius = choosePhotoButton.bounds.height / 2
        choosePhotoButton.imageEdgeInsets = UIEdgeInsets(all: .choosePhotoButtonEdgeInsets)
        
        photoImageView.layer.masksToBounds = true
        photoImageView.layer.cornerRadius = choosePhotoButton.bounds.height / 2
    }

}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        dataManager.state.imageData = image.jpegData(compressionQuality: 1)
        photoImageView.image = image
        saveButton.isEnabled = true
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension ProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if saveButton.isEnabled == false {
            saveButton.isEnabled = true
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        dataManager.state.name = textField.text
        textField.resignFirstResponder()
    }
}

// MARK: - UITextViewDelegate
extension ProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if saveButton.isEnabled == false {
            saveButton.isEnabled = true
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
        dataManager.state.aboutMe = textView.text
    }
}
