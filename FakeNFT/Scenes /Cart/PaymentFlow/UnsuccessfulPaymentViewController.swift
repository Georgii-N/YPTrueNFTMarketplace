//
//  UnsuccessfulPaymentViewController.swift
//  FakeNFT
//
//  Created by Даниил Крашенинников on 01.08.2023.
//

import UIKit

final class UnsuccessfulPaymentViewController: UIViewController {
    
    // MARK: UI constants and variables
    let tryButton = BaseBlackButton(with: L10n.Cart.UnsuccessfulPayment.tryAgain)
   
    private lazy var unsuccessefulImage: UIImageView = {
        let unsuccessefulImage = UIImageView()
        unsuccessefulImage.image = UIImage(named: "unsuccess")
        return unsuccessefulImage
    }()
    
    private lazy var unsuccessefulLabel: UILabel = {
        let unsuccessefulLabel = UILabel()
        unsuccessefulLabel.numberOfLines = 2
        unsuccessefulLabel.textAlignment = .center
        unsuccessefulLabel.textColor = .blackDay
        unsuccessefulLabel.font = UIFont.boldSystemFont(ofSize: 22)
        unsuccessefulLabel.sizeToFit()
        unsuccessefulLabel.text = L10n.Cart.UnsuccessfulPayment.unsuccessful
        return unsuccessefulLabel
    }()
    
    // MARK: - Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setupConstraints()
        setTargets()
    }
}

// MARK: Set Up UI
extension UnsuccessfulPaymentViewController {
    
    func setUpViews() {
        view.backgroundColor = .whiteDay
        [unsuccessefulImage, unsuccessefulLabel, tryButton].forEach(view.setupView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            unsuccessefulImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 152),
            unsuccessefulImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            unsuccessefulLabel.topAnchor.constraint(equalTo: unsuccessefulImage.bottomAnchor, constant: 20),
            unsuccessefulLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            unsuccessefulLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -17),
            tryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            tryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tryButton.widthAnchor.constraint(equalToConstant: 343)
        ])
    }
    
    func setTargets() {
        // to do
    }
}
