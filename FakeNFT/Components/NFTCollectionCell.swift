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
        imageView.backgroundColor = .blueUniversal
        
        return imageView
    }()
    
    private lazy var nftLikeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart.fill")
        
        return imageView
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
    
    static var statisticReuseIdentifier = "NFTCollectionViewCell"
    
    // MARK: - Lifecycle:
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 12
        
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Public Methods:
    func setNFTImageView(image: UIImage) {
        nftImageView.image = image
    }
    
    func setNFTName(name: String) {
        nftNameLabel.text = name
    }
    
    // MARK: - Prive Methods:
//    private func setupRatingStackView() {
//        (1...5).forEach { _ in
//            let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
//            ratingStackView.addSubview(<#T##view: UIView##UIView#>)
//        }
//    }
}

// MARK: - Setup Views:
extension NFTCollectionCell {
    private func setupViews() {
        contentView.setupView(nftImageView)
        nftImageView.setupView(nftLikeImageView)
        contentView.setupView(nftNameLabel)
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
            
            // Like image:
            nftLikeImageView.heightAnchor.constraint(equalToConstant: 40),
            nftLikeImageView.widthAnchor.constraint(equalToConstant: 40),
            nftLikeImageView.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            nftLikeImageView.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            
            // NFT name:
            nftNameLabel.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 25),
            nftNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
}
