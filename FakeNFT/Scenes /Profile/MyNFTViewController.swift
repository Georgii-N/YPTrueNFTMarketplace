//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Тихтей  Павел on 01.08.2023.
//

import UIKit

class MyNFTViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupConstraints()
    }
    
    private func setupBackground() {
        view.backgroundColor = .whiteDay
        view.tintColor = .blackDay
    }
    
    private lazy var goBackButton: UIButton = {
        let goBackButton = UIButton()
        goBackButton.setImage(UIImage(named: "goBack"), for: .normal)
        goBackButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(goBackButton)
        return goBackButton
    }()
    
    private lazy var myNFTTitle: UILabel = {
        let myNFTTitle = UILabel()
        myNFTTitle.font = .bodyBold
        myNFTTitle.text = "Мои NFT"
        myNFTTitle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(myNFTTitle)
        return myNFTTitle
    }()
    
    private lazy var sortButton: UIButton = {
        let sortButton = UIButton()
        sortButton.setImage(UIImage(named: "sort"), for: .normal)
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sortButton)
        return sortButton
    }()
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Back Button
            goBackButton.widthAnchor.constraint(equalToConstant: 24),
            goBackButton.heightAnchor.constraint(equalToConstant: 24),
            goBackButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 55),
            goBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            // MyNFT Title
            myNFTTitle.centerYAnchor.constraint(equalTo: goBackButton.centerYAnchor),
            myNFTTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Sort Button
            sortButton.centerYAnchor.constraint(equalTo: myNFTTitle.centerYAnchor),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func goBackButtonTapped() {
        dismiss(animated: true)
    }
}
