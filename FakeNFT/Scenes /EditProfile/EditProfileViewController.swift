//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Тихтей  Павел on 01.08.2023.
//

import UIKit
import Kingfisher

class EditProfileViewController: UIViewController {
    
    weak var delegate: ProfileViewControllerDelegate?
    var profile: Profile?

    private var photoLink: String?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupConstrains()
        guard let imageUrl = URL(string: profile?.avatar ?? "") else { return }
        KingfisherManager.shared.retrieveImage(with: imageUrl) { [weak self] result in
            switch result {
            case .success(let imageResult):
                self?.editAvatarButton.setImage(imageResult.image, for: .normal)
            case .failure(let error):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: error)
                self?.showErrorAlert(message: errorString ?? "")
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let profile = profile else { return }
        let updateProfile = Profile(name: nameTextField.text ?? "",
                                    avatar: photoLink ?? profile.avatar,
                                    description: descriptionTextField.text ?? profile.description,
                                    website: siteTextField.text ?? profile.website,
                                    nfts: profile.nfts,
                                    likes: profile.likes,
                                    id: profile.id)
        delegate?.updateProfile(profile: updateProfile)
    }
    
    // MARK: - SetupUI
    
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
        editAvatarButton.backgroundColor = UIColor(red: 0.1, green: 0.11, blue: 0.13, alpha: 0.6)
        editAvatarButton.layer.cornerRadius = 35
        editAvatarButton.setTitle(L10n.Profile.EditScreen.changePhoto, for: .normal)
        editAvatarButton.titleLabel?.numberOfLines = 0
        editAvatarButton.titleLabel?.font = .systemFont(ofSize: 10)
        editAvatarButton.setTitleColor(.white, for: .normal)
        editAvatarButton.titleLabel?.textAlignment = .center
        editAvatarButton.clipsToBounds = true
        editAvatarButton.layer.zPosition = 2
        editAvatarButton.addTarget(self, action: #selector(editAvatarButtonTapped), for: .touchUpInside)
        editAvatarButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(editAvatarButton)
        return editAvatarButton
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = L10n.Profile.EditScreen.name
        nameLabel.font = .captionLargeBold
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
        nameTextField.font = .bodyMediumRegular
        nameTextField.textAlignment = .left
        nameTextField.text = profile?.name
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameUnderView.addSubview(nameTextField)
        return nameTextField
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = L10n.Profile.EditScreen.description
        descriptionLabel.font = .captionLargeBold
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
        descriptionTextField.font = .bodyMediumRegular
        descriptionTextField.textAlignment = .left
        descriptionTextField.contentVerticalAlignment = .top
        descriptionTextField.text = profile?.description
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionUnderView.addSubview(descriptionTextField)
        return descriptionTextField
    }()
    
    private lazy var siteLabel: UILabel = {
        let siteLabel = UILabel()
        siteLabel.text = L10n.Profile.EditScreen.site
        siteLabel.font = .captionLargeBold
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
        siteTextField.font = .bodyMediumRegular
        siteTextField.text = profile?.website
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
            descriptionTextField.topAnchor.constraint(equalTo: descriptionUnderView.topAnchor, constant: 11),
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
    
    // MARK: - Alert
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }
    
    private func showURLInputAlert() {
        let alert = UIAlertController(
            title: "Добавить изображение",
            message: "Укажите ссылку на фото",
            preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Введите ссылку"
        }
        let okAction = UIAlertAction(
            title: "Ок",
            style: .default) { [weak self] _ in
                self?.photoLink = alert.textFields?.first?.text ?? ""
            }
        
        let cancelAction = UIAlertAction(
            title: "Отмена",
            style: .cancel
        )
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func isValidURL(urlString: String) -> Bool {
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else {
            return false
        }
        return true
    }
    
    private func showInvalidURLAlert() {
        let alert = UIAlertController(
            title: NSLocalizedString("profile.photo.invalidURLTitle", comment: ""),
            message: NSLocalizedString("profile.photo.invalidURLMessage", comment: ""),
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(
            title: NSLocalizedString("profile.photo.okButton", comment: ""),
            style: .cancel
        )
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Actions
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func editAvatarButtonTapped() {
        showURLInputAlert()
    }
}
