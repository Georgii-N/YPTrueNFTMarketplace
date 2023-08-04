//
//  SuccessfulPaymentViewController.swift
//  FakeNFT
//
//  Created by Даниил Крашенинников on 01.08.2023.
//

import UIKit

final class SuccessfulPaymentViewController: UIViewController {
    
    // MARK: UI constants and variables
    private let returnInCatalogButton = BaseBlackButton(with: L10n.Cart.SuccessfulPayment.toBackCatalogButton)
   
    private lazy var successefulImage: UIImageView = {
        let successefulImage = UIImageView()
        successefulImage.image = UIImage(named: "successfulPayment")
        return successefulImage
    }()
    
    private lazy var successefulLabel: UILabel = {
        let successefulLabel = UILabel()
        successefulLabel.numberOfLines = 2
        successefulLabel.textAlignment = .center
        successefulLabel.textColor = .blackDay
        successefulLabel.font = UIFont.boldSystemFont(ofSize: 22)
        successefulLabel.text = L10n.Cart.SuccessfulPayment.successful
        return successefulLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setupConstraints()
        setTargets()
    }
}

// MARK: Set Up UI
extension SuccessfulPaymentViewController {
    
   private func setUpViews() {
        view.backgroundColor = .whiteDay
        [successefulImage, successefulLabel, returnInCatalogButton].forEach(view.setupView)
    }
    
   private func setupConstraints() {
        NSLayoutConstraint.activate([
            successefulImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 152),
            successefulImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successefulLabel.topAnchor.constraint(equalTo: successefulImage.bottomAnchor, constant: 20),
            successefulLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 36),
            successefulLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -36),
            returnInCatalogButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            returnInCatalogButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            returnInCatalogButton.widthAnchor.constraint(equalToConstant: 343)
        ])
    }
    
   private func setTargets() {
        // to do
    }
}
