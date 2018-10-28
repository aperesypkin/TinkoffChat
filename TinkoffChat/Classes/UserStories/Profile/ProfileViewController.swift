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
    
    private struct Keys {
        static let profileState = "ProfileState"
    }
    
    private struct State: Codable {
        var name: String? = "Unnamed"
        var aboutMe: String? = "Информация о пользователе"
        var imageData: Data?
    }
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var editButton: TCButton!
    @IBOutlet weak var saveButtonsStack: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aboutMeTextView: UITextView! {
        didSet {
            aboutMeTextView.delegate = self
        }
    }
    @IBOutlet weak var aboutMeLabel: UILabel!
    @IBOutlet weak var aboutMeContainer: UIView!
    @IBOutlet weak var operationButton: TCButton!
    @IBOutlet weak var gcdButton: TCButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            nameTextField.delegate = self
        }
    }
    @IBOutlet weak var choosePhotoButton: UIButton!
    
    private var dataManagerType: DataManagerType = .gcd
    
    private var state = State()
    
    private var isEditMode: Bool = false {
        didSet {
            editButton.isHidden = isEditMode
            nameLabel.isHidden = isEditMode
            aboutMeContainer.isHidden = isEditMode
            
            saveButtonsStack.isHidden = !isEditMode
            nameTextField.isHidden = !isEditMode
            aboutMeTextView.isHidden = !isEditMode
            
            choosePhotoButton.isHidden.toggle()
        }
    }
    
    private var isSaveButtonsEnabled: Bool = false {
        didSet {
            gcdButton.isEnabled = isSaveButtonsEnabled
            operationButton.isEnabled = isSaveButtonsEnabled
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
        isSaveButtonsEnabled = false
    }
    
    @IBAction func didTapGCDButton(_ sender: TCButton) {
        view.endEditing(true)
        dataManagerType = .gcd
        saveData()
    }
    
    @IBAction func didTapOperationButton(_ sender: TCButton) {
        view.endEditing(true)
        dataManagerType = .operation
        saveData()
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func saveData() {
        activityIndicator.startAnimating()
        isSaveButtonsEnabled = false
        dataManagerType.dataManager().save(state, to: Keys.profileState) { [weak self] error in
            guard let `self` = self else { return }
            self.activityIndicator.stopAnimating()
            self.isSaveButtonsEnabled = true
            if let error = error {
                print("Error: \(error)")
                self.present(self.failureAlert, animated: true)
            } else {
                self.present(self.successfulAlert, animated: true)
            }
        }
    }
    
    private func loadData() {
        activityIndicator.startAnimating()
        isSaveButtonsEnabled = false
        dataManagerType.dataManager().load(State.self, from: Keys.profileState) { [weak self] data, error in
            guard let `self` = self else { return }
            if let profileState = data {
                self.state = profileState
            }
            self.updateData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func updateData() {
        self.nameLabel.text = state.name
        self.nameTextField.text = state.name
        self.aboutMeLabel.text = state.aboutMe
        self.aboutMeTextView.text = state.aboutMe
        if let imageData = state.imageData {
            self.photoImageView.image = UIImage(data: imageData)
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        state.imageData = image.jpegData(compressionQuality: 1)
        photoImageView.image = image
        isSaveButtonsEnabled = true
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension ProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if isSaveButtonsEnabled == false {
            isSaveButtonsEnabled = true
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        state.name = textField.text
        textField.resignFirstResponder()
    }
}

// MARK: - UITextViewDelegate
extension ProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if isSaveButtonsEnabled == false {
            isSaveButtonsEnabled = true
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
        state.aboutMe = textView.text
    }
}

// MARK: - Keyboard
extension ProfileViewController {
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y != 0 {
                view.frame.origin.y += keyboardSize.height
            }
        }
    }
}
