//
//  CartPaymentCell.swift
//  FakeNFT
//
//  Created by Даниил Крашенинников on 31.07.2023.
//

import UIKit

final class CartPaymentCell: UICollectionViewCell {
    
    // MARK: UI constants and variables
    private lazy var backView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .lightGray
        backgroundView.layer.cornerRadius = 12
        return backgroundView
    }()
    
    private lazy var nameCoin: UILabel = {
        let nameCoin = UILabel()
        nameCoin.textColor = .blackDay
        nameCoin.font = UIFont.boldSystemFont(ofSize: 13)
        nameCoin.text = "Bitcoin"
        return nameCoin
    }()
    
    private lazy var imageCoin: UIImageView = {
        let imageCoin = UIImageView()
        imageCoin.image = UIImage(named: "mokCoin")
        return imageCoin
    }()
    
    private lazy var shortNameCoin: UILabel = {
        let shortNameCoin = UILabel()
        shortNameCoin.textColor = .greenUniversal
        shortNameCoin.font = UIFont.systemFont(ofSize: 13)
        shortNameCoin.text = "BTC"
        return shortNameCoin
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Set Up UI
extension CartPaymentCell {
   private func setUpViews() {
        [backView, nameCoin, imageCoin, shortNameCoin].forEach(contentView.setupView)
    }
    
   private func setupConstraints() {
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageCoin.topAnchor.constraint(equalTo: backView.topAnchor, constant: 5),
            imageCoin.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 12),
            nameCoin.topAnchor.constraint(equalTo: backView.topAnchor, constant: 5),
            nameCoin.leadingAnchor.constraint(equalTo: imageCoin.trailingAnchor, constant: 4),
            shortNameCoin.topAnchor.constraint(equalTo: nameCoin.bottomAnchor),
            shortNameCoin.leadingAnchor.constraint(equalTo: imageCoin.trailingAnchor, constant: 4)
        ])
    }
}

extension CartPaymentCell: ReuseIdentifying {
    static var defaultReuseIdentifier = "cellPayment"
}
