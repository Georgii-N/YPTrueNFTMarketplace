//
//  DeleteItemViewControler.swift
//  FakeNFT
//
//  Created by Даниил Крашенинников on 01.08.2023.
//

import UIKit

protocol DeleteViewControllerDelegate: AnyObject {
    func deleteNft(itemId: String)
}

final class DeleteItemViewControler: UIViewController {
    
    // MARK: Public dependencies
    weak var delegate: DeleteViewControllerDelegate?
    var itemImage: UIImage
    var itemId: String
    
    // MARK: UI constants and variables
    private let blurEffect = UIBlurEffect(style: .light)
    
    private lazy var itemImageView: UIImageView = {
        let itemImageView = UIImageView()
        itemImageView.image = itemImage
        itemImageView.layer.masksToBounds = true
        itemImageView.layer.cornerRadius = 12
        return itemImageView
    }()
    
    private lazy var alertlLabel: UILabel = {
        let alertlLabel = UILabel()
        alertlLabel.numberOfLines = 2
        alertlLabel.textAlignment = .center
        alertlLabel.textColor = .blackDay
        alertlLabel.font = UIFont.systemFont(ofSize: 13)
        alertlLabel.text = L10n.Cart.MainScreen.deleteItemAlert
        return alertlLabel
    }()
    
    private lazy var deleteItemButton: UIButton = {
        let deleteCartButton = UIButton()
        deleteCartButton.backgroundColor = .blackDay
        deleteCartButton.setTitle(L10n.Cart.MainScreen.deleteItemButton, for: .normal)
        deleteCartButton.setTitleColor(.red, for: .normal)
        deleteCartButton.layer.cornerRadius = 12
        deleteCartButton.titleLabel?.textAlignment = .center
        deleteCartButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return deleteCartButton
    }()
    
    private lazy var returnToCartButton: UIButton = {
        let returnToCartButton = UIButton()
        returnToCartButton.backgroundColor = .blackDay
        returnToCartButton.setTitle(L10n.Cart.MainScreen.returnButton, for: .normal)
        returnToCartButton.setTitleColor(.whiteDay, for: .normal)
        returnToCartButton.layer.cornerRadius = 12
        returnToCartButton.titleLabel?.textAlignment = .center
        returnToCartButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return returnToCartButton
    }()
    
    // MARK: - Lifecycle:
    init(itemImage: UIImage, itemId: String) {
        self.itemImage = itemImage
        self.itemId = itemId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setupConstraints()
        setTargets()
    }
}

// MARK: Set Up UI
extension DeleteItemViewControler {
    
    private func setUpViews() {
        let blurEffectView = UIVisualEffectView(effect: self.blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        [blurEffectView, itemImageView, alertlLabel, deleteItemButton, returnToCartButton].forEach(view.setupView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            itemImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 244),
            itemImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertlLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 12),
            alertlLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 97),
            alertlLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -98),
            deleteItemButton.topAnchor.constraint(equalTo: alertlLabel.bottomAnchor, constant: 20),
            deleteItemButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 56),
            deleteItemButton.widthAnchor.constraint(equalToConstant: 127),
            deleteItemButton.heightAnchor.constraint(equalToConstant: 44),
            returnToCartButton.topAnchor.constraint(equalTo: alertlLabel.bottomAnchor, constant: 20),
            returnToCartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -57),
            returnToCartButton.widthAnchor.constraint(equalToConstant: 127),
            returnToCartButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    private func setTargets() {
        returnToCartButton.addTarget(self, action: #selector(returnToCart), for: .touchUpInside)
        deleteItemButton.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
    }
    
    // MARK: Private Methods
    @objc
    private func returnToCart() {
        dismiss(animated: true)
    }
    
    @objc
    private func deleteItem() {
        dismiss(animated: true)
        delegate?.deleteNft(itemId: itemId)
    }
}
