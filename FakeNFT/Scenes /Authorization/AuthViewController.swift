//
//  AuthViewController.swift
//  FakeNFT
//
//  Created by Евгений on 09.08.2023.
//

import UIKit

final class AuthViewController: UIViewController {
    
    // MARK: - UI:
    private lazy var authScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        
        return scrollView
    }()
        
    private lazy var enterTittleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 34)
        label.textColor = .blackDay
        label.text = L10n.Authorization.enter
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 12
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.textColor = .blackDay
        textField.backgroundColor = .lightGrayDay
        textField.placeholder = "Email"
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 12
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.textColor = .blackDay
        textField.backgroundColor = .lightGrayDay
        textField.placeholder = L10n.Authorization.password
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var enterButton = BaseBlackButton(with: L10n.Authorization.entering)
    
    private lazy var forgetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle(L10n.Authorization.forgetPassword, for: .normal)
        button.setTitleColor(.blackDay, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        
        return button
    }()
    
    private lazy var demoButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle(L10n.Authorization.demo, for: .normal)
        button.setTitleColor(.blueUniversal, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        
        return button
    }()
    
    private lazy var registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle(L10n.Authorization.ragistration, for: .normal)
        button.setTitleColor(.blackDay, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        
        return button
    }()
    
    // MARK: - Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupObservers()
        
        initializeHideKeyboard()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Private Methods:
    private func setupObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidHide),
                                               name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    private func initializeHideKeyboard() {
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(gesture)
    }
    
    // MARK: - Objc Methods:
    @objc private func keyboardDidShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.authScrollView.contentSize.height = authScrollView.frame.height + keyboardFrameSize.height
            self.authScrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrameSize.height, right: 0)
        }
    }
        
    @objc private func keyboardDidHide() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            authScrollView.contentSize.height = authScrollView.frame.height
        }
    }
    
    @objc func dismissMyKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate
extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

// MARK: - Setup Views:
extension AuthViewController {
    private func setupViews() {
        view.backgroundColor = .whiteDay
        
        view.setupView(authScrollView)
        [enterTittleLabel, emailTextField, passwordTextField, enterButton,
         forgetPasswordButton, demoButton, registrationButton].forEach(authScrollView.setupView)
    }
}

// MARK: - Setup Views:
extension AuthViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            authScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            authScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            authScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            authScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            enterTittleLabel.topAnchor.constraint(equalTo: authScrollView.topAnchor, constant: 132),
            enterTittleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            enterTittleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            emailTextField.heightAnchor.constraint(equalToConstant: 46),
            emailTextField.topAnchor.constraint(equalTo: enterTittleLabel.bottomAnchor, constant: 50),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            passwordTextField.heightAnchor.constraint(equalToConstant: 46),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            enterButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 84),
            enterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            enterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            forgetPasswordButton.topAnchor.constraint(equalTo: enterButton.bottomAnchor, constant: 16),
            forgetPasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            forgetPasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            demoButton.heightAnchor.constraint(equalToConstant: 60),
            demoButton.topAnchor.constraint(equalTo: forgetPasswordButton.bottomAnchor, constant: 67),
            demoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            demoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            registrationButton.heightAnchor.constraint(equalToConstant: 60),
            registrationButton.topAnchor.constraint(equalTo: demoButton.bottomAnchor, constant: 12),
            registrationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            registrationButton.bottomAnchor.constraint(lessThanOrEqualTo: authScrollView.bottomAnchor, constant: -60),
            registrationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
