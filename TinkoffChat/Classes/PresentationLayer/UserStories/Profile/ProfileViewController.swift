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
    
    // MARK: - UI
    
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
    
    // MARK: - Private properties
    
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
    
    // MARK: - Dependencies
    
    private let dataManager: IProfileDataManager
    
    // MARK: - Initialization
    
    init(dataManager: IProfileDataManager) {
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
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateUI()
    }
    
    // MARK: - IB Actions
    
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
    
    // MARK: - Private methods
    
    private func setup() {
        title = "Профиль"
        setupKeyboardNotifications()
        setupCloseBarButton()
        imagePicker.delegate = self
    }
    
    private func setupCloseBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(didTapCloseButton))
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true)
    }
    
    private func saveData() {
        activityIndicator.startAnimating()
        saveButton.isEnabled = false
        dataManager.saveProfile()
    }
    
    private func loadData() {
        activityIndicator.startAnimating()
        saveButton.isEnabled = false
        dataManager.loadProfile()
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
        dataManager.set(imageData: image.jpegData(compressionQuality: 1))
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
        dataManager.set(name: textField.text)
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
        dataManager.set(aboutMe: textView.text)
    }
}

// MARK: - IProfileDataManagerDelegate
extension ProfileViewController: IProfileDataManagerDelegate {
    func didLoadUser(name: String?, aboutMe: String?, imageData: Data?) {
        self.activityIndicator.stopAnimating()
        nameLabel.text = name
        nameTextField.text = name
        aboutMeLabel.text = aboutMe
        aboutMeTextView.text = aboutMe
        if let imageData = imageData {
            photoImageView.image = UIImage(data: imageData)
        }
    }
    
    func didSaveUser() {
        saveButton.isEnabled = true
        activityIndicator.stopAnimating()
        present(successfulAlert, animated: true)
    }
    
    func didReceiveSave(error: String) {
        print(error)
        present(failureAlert, animated: true)
    }
    
    func didReceiveLoad(error: String) {
        print(error)
        activityIndicator.stopAnimating()
    }
}
