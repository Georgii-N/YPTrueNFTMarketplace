//
//  NFTCollectionCell.swift
//  FakeNFT
//
//  Created by Евгений on 01.08.2023.
//

import UIKit

final class NFTCollectionCell: UICollectionViewCell, ReuseIdentifying {
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .systemBlue
        
        return imageView
    }()
    
    private lazy var nftLikeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    private lazy var nftLikeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Resources.Images.NFTCollectionCell.unlikedButton, for: .normal)
        
        return button
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .blackDay
        label.text = "Archie"
        
        return label
    }()
    
    private lazy var nftPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .blackDay
        label.text = "1 ETH"
        
        return label
    }()
    
    private lazy var cartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .whiteDay
        
        return imageView
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Resources.Images.NFTCollectionCell.putInBasket, for: .normal)
        button.contentMode = .center
        
        return button
    }()
    
    static var defaultReuseIdentifier = "NFTCollectionViewCell"
    
    // MARK: - Lifecycle:
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 12
        
        setupViews()
        setupConstraints()
        setupTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods:
    func setNFTImageView(image: UIImage) {
        nftImageView.image = image
    }
    
    func setNFTName(name: String) {
        nftNameLabel.text = name
    }
    
    // MARK: - Prive Methods:
    private func setupRatingStackView() {
        (1...5).forEach { [weak self] _ in
            guard let self = self else { return }
            let imageView = UIImageView(image: Resources.Images.NFTCollectionCell.goldRatingStar)
            
            self.ratingStackView.addArrangedSubview(imageView)
        }
    }
    
    @objc private func likeButtonDidTapped() {
        let baseImage = Resources.Images.NFTCollectionCell.unlikedButton
        let image = nftLikeButton.imageView?.image == baseImage ? Resources.Images.NFTCollectionCell.likedButton : Resources.Images.NFTCollectionCell.unlikedButton
        
        nftLikeButton.setImage(image, for: .normal)
    }
}

// MARK: - Setup Views:
extension NFTCollectionCell {
    private func setupViews() {
        backgroundColor = .whiteDay
        
        setupRatingStackView()
        
        contentView.setupView(nftImageView)
        nftImageView.setupView(nftLikeImageView)
        contentView.setupView(nftLikeButton)
        contentView.setupView(ratingStackView)
        contentView.setupView(nftNameLabel)
        contentView.setupView(nftPriceLabel)
        contentView.setupView(cartImageView)
        contentView.setupView(cartButton)
    }
}

// MARK: - Setup Constraints:
extension NFTCollectionCell {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // NFT image:
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            // Like imageView:
            nftLikeImageView.heightAnchor.constraint(equalToConstant: 40),
            nftLikeImageView.widthAnchor.constraint(equalToConstant: 40),
            nftLikeImageView.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            nftLikeImageView.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            
            // Like button:
            nftLikeButton.heightAnchor.constraint(equalToConstant: 18),
            nftLikeButton.widthAnchor.constraint(equalToConstant: 22),
            nftLikeButton.centerXAnchor.constraint(equalTo: nftLikeImageView.centerXAnchor),
            nftLikeButton.centerYAnchor.constraint(equalTo: nftLikeImageView.centerYAnchor),
            
            // Rating stackView:
            ratingStackView.heightAnchor.constraint(equalToConstant: 12),
            ratingStackView.widthAnchor.constraint(equalToConstant: 68),
            ratingStackView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            ratingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            // NFT name:
            nftNameLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 5),
            nftNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            // NFT price:
            nftPriceLabel.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 4),
            nftPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            // Cart imageView:
            cartImageView.heightAnchor.constraint(equalToConstant: 40),
            cartImageView.widthAnchor.constraint(equalToConstant: 40),
            cartImageView.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 4),
            cartImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Cart button:
            cartButton.widthAnchor.constraint(equalToConstant: 18),
            cartButton.heightAnchor.constraint(equalToConstant: 20),
            cartButton.centerXAnchor.constraint(equalTo: cartImageView.centerXAnchor),
            cartButton.centerYAnchor.constraint(equalTo: cartImageView.centerYAnchor)
        ])
    }
}

// MARK: - Setup Targets:
extension NFTCollectionCell {
    private func setupTargets() {
        nftLikeButton.addTarget(self, action: #selector(likeButtonDidTapped), for: .touchUpInside)
    }
}
