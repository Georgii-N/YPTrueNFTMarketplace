//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Тихтей  Павел on 01.08.2023.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupConstrains()
    }
    
    private func setupBackground() {
        view.backgroundColor = .whiteDay
        view.tintColor = .blackDay
    }
    
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "closeButton"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        return closeButton
    }()
    
    private lazy var editAvatarButton: UIButton = {
        let editAvatarButton = UIButton()
        editAvatarButton.setImage(UIImage(named: "profileMockImage"), for: .normal)
        editAvatarButton.layer.cornerRadius = 35
        editAvatarButton.clipsToBounds = true
        
        let changeAvatarLabel = UILabel()
        changeAvatarLabel.text = "Сменить фото"
        changeAvatarLabel.font = .systemFont(ofSize: 10)
//        editAvatarButton.addSubview(upperView)
//        upperView.addSubview(changeAvatarLabel)
        editAvatarButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(editAvatarButton)
        return editAvatarButton
    }()
    
    private lazy var editAvatarButtonLayer: UIView = {
        let editAvatarButtonLayer = UIView()
        editAvatarButtonLayer.backgroundColor = UIColor(red: 0.1, green: 0.11, blue: 0.13, alpha: 0.6)
        editAvatarButtonLayer.translatesAutoresizingMaskIntoConstraints = false
        editAvatarButton.addSubview(editAvatarButtonLayer)
        return editAvatarButtonLayer
    }()
    
    private lazy var editAvatarLabel: UILabel = {
        let editAvatarLabel = UILabel()
        editAvatarLabel.text = L10n.Profile.EditScreen.changePhoto
        editAvatarLabel.textColor = .whiteDay
        editAvatarLabel.tintColor = .blackDay
        editAvatarLabel.font = .systemFont(ofSize: 10)
        editAvatarLabel.numberOfLines = 2
        editAvatarLabel.translatesAutoresizingMaskIntoConstraints = false
        editAvatarButtonLayer.addSubview(editAvatarLabel)
        return editAvatarLabel
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = L10n.Profile.EditScreen.name
        nameLabel.font = .headline3
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        return nameLabel
    }()
    
    private lazy var nameUnderView: UIView = {
        let nameUnderView = UIView()
        nameUnderView.layer.cornerRadius = 12
        nameUnderView.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.973, alpha: 1)
        nameUnderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameUnderView)
        return nameUnderView
    }()
    
    private lazy var nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.font = .bodyRegular
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameUnderView.addSubview(nameTextField)
        return nameTextField
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = L10n.Profile.EditScreen.description
        descriptionLabel.font = .headline3
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        return descriptionLabel
    }()
    
    private lazy var descriptionUnderView: UIView = {
        let descriptionUnderView = UIView()
        descriptionUnderView.layer.cornerRadius = 12
        descriptionUnderView.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.973, alpha: 1)
        descriptionUnderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionUnderView)
        return descriptionUnderView
    }()
    
    private lazy var descriptionTextField: UITextField = {
        let descriptionTextField = UITextField()
        descriptionTextField.font = .bodyRegular
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionUnderView.addSubview(descriptionTextField)
        return descriptionTextField
    }()
    
    private lazy var siteLabel: UILabel = {
        let siteLabel = UILabel()
        siteLabel.text = L10n.Profile.EditScreen.site
        siteLabel.font = .headline3
        siteLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(siteLabel)
        return siteLabel
    }()
    
    private lazy var siteUnderView: UIView = {
        let siteUnderView = UIView()
        siteUnderView.layer.cornerRadius = 12
        siteUnderView.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.973, alpha: 1)
        siteUnderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(siteUnderView)
        return siteUnderView
    }()
    
    private lazy var siteTextField: UITextField = {
        let siteTextField = UITextField()
        siteTextField.font = .bodyRegular
        siteTextField.translatesAutoresizingMaskIntoConstraints = false
        siteUnderView.addSubview(siteTextField)
        return siteTextField
    }()
    
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            // Close Button
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            closeButton.heightAnchor.constraint(equalToConstant: 42),
            closeButton.widthAnchor.constraint(equalToConstant: 42),
            
            // Edit Avatar Button
            editAvatarButton.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 22),
            editAvatarButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editAvatarButton.heightAnchor.constraint(equalToConstant: 70),
            editAvatarButton.widthAnchor.constraint(equalToConstant: 70),
            
            editAvatarButtonLayer.leadingAnchor.constraint(equalTo: editAvatarButton.leadingAnchor),
            editAvatarButtonLayer.trailingAnchor.constraint(equalTo: editAvatarButton.trailingAnchor),
            editAvatarButtonLayer.topAnchor.constraint(equalTo: editAvatarButton.topAnchor),
            editAvatarButtonLayer.bottomAnchor.constraint(equalTo: editAvatarButton.bottomAnchor),
            
            editAvatarLabel.centerXAnchor.constraint(equalTo: editAvatarButtonLayer.centerXAnchor),
            editAvatarLabel.centerYAnchor.constraint(equalTo: editAvatarButtonLayer.centerYAnchor),
            
            // Name
            nameLabel.topAnchor.constraint(equalTo: editAvatarButton.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            nameUnderView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameUnderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameUnderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameUnderView.heightAnchor.constraint(equalToConstant: 44),
            
            nameTextField.leadingAnchor.constraint(equalTo: nameUnderView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: nameUnderView.trailingAnchor, constant: -16),
            nameTextField.centerYAnchor.constraint(equalTo: nameUnderView.centerYAnchor),
            
            // Description
            descriptionLabel.topAnchor.constraint(equalTo: nameUnderView.bottomAnchor, constant: 22),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            descriptionUnderView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionUnderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionUnderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionUnderView.heightAnchor.constraint(equalToConstant: 135),
            
            descriptionTextField.leadingAnchor.constraint(equalTo: descriptionUnderView.leadingAnchor, constant: 16),
            descriptionTextField.trailingAnchor.constraint(equalTo: descriptionUnderView.trailingAnchor, constant: -16),
            descriptionTextField.topAnchor.constraint(equalTo: descriptionUnderView.topAnchor, constant: -11),
            descriptionTextField.bottomAnchor.constraint(equalTo: descriptionUnderView.bottomAnchor, constant: 11),
            
            // Site
            siteLabel.topAnchor.constraint(equalTo: descriptionUnderView.bottomAnchor, constant: 22),
            siteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            siteUnderView.topAnchor.constraint(equalTo: siteLabel.bottomAnchor, constant: 8),
            siteUnderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            siteUnderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            siteUnderView.heightAnchor.constraint(equalToConstant: 44),
            
            siteTextField.leadingAnchor.constraint(equalTo: siteUnderView.leadingAnchor, constant: 16),
            siteTextField.trailingAnchor.constraint(equalTo: siteUnderView.trailingAnchor, constant: -16),
            siteTextField.centerYAnchor.constraint(equalTo: siteUnderView.centerYAnchor)
        ])
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}
