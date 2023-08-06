//
//  FavouritesNFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by Тихтей  Павел on 04.08.2023.
//

import UIKit

class FavouritesNFTCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    
    static var defaultReuseIdentifier: String = "FavouritesNFTCell"
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetupUI
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .bodyBold
        return nameLabel
    }()
    
    private lazy var rateImage: UIImageView = {
        let rateImage = UIImageView()
        return rateImage
    }()
    
    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = .caption1
        return priceLabel
    }()
    
    private func setupViews() {
        [imageView, nameLabel, rateImage, priceLabel].forEach(contentView.setupView(_:))
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Image View
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            rateImage.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            rateImage.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            rateImage.widthAnchor.constraint(equalToConstant: 70),
            
            priceLabel.topAnchor.constraint(equalTo: rateImage.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func setupCellData(_ model: FavouritesNFTCellViewModel) {
        imageView.image = model.NFTImage
        nameLabel.text = model.NFTName
        rateImage.image = model.NFTRateImage
        priceLabel.text = model.NFTPrice + " ETH"
    }
}
