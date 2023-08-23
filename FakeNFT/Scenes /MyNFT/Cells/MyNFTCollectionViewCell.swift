//
//  MyNFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by Тихтей  Павел on 03.08.2023.
//

import UIKit

protocol MyNFTCollectionViewCellDelegate: AnyObject {
    func didTapLikeButton(id: String)
}

class MyNFTCollectionViewCell: UICollectionViewCell {
    
    private var model: NFTCell?

    weak var delegate: MyNFTCollectionViewCellDelegate?
    
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
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 12
        imageView.kf.indicatorType = .activity
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.setImage(UIImage(named: "unliked"), for: .normal)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return likeButton
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .bodyMediumBold
        return nameLabel
    }()
    
    private lazy var rateImage: UIImageView = {
        let rateImage = UIImageView()
        return rateImage
    }()
    
    private lazy var fromLabel: UILabel = {
        let fromLabel = UILabel()
        fromLabel.font = .bodySmallRegular
        return fromLabel
    }()
    
    private lazy var priceTitleLabel: UILabel = {
        let priceTitleLabel = UILabel()
        priceTitleLabel.font = .bodySmallerRegular
        priceTitleLabel.text = L10n.General.price
        return priceTitleLabel
    }()
    
    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = .headlineSmall
        return priceLabel
    }()
    
    private func setupViews() {
        [imageView, nameLabel, rateImage, fromLabel, priceTitleLabel, priceLabel].forEach(contentView.setupView(_:))
        imageView.setupView(likeButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Image View
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 108),
            
            // Like Button
            likeButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 12),
            likeButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -12),
            likeButton.widthAnchor.constraint(equalToConstant: 18),
            likeButton.heightAnchor.constraint(equalToConstant: 16),
            
            // Name Label
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 23),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),
            nameLabel.widthAnchor.constraint(equalToConstant: 78),
            
            // Rate Image
            rateImage.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            rateImage.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),
            rateImage.widthAnchor.constraint(equalToConstant: 78),
            
            // From Label
            fromLabel.topAnchor.constraint(equalTo: rateImage.bottomAnchor, constant: 4),
            fromLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),
            fromLabel.widthAnchor.constraint(equalToConstant: 78),
            
            // Price Title Label
            priceTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 33),
            priceTitleLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 70),
            priceTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            // Price Label
            priceLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 2),
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 70),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    @objc func likeButtonTapped() {
        guard let id = model?.id else { return }
        delegate?.didTapLikeButton(id: id)
    }
    
    private func setRateImage(_ number: Int) {
        switch number {
        case 0:
            rateImage.image = RateImages.rateZero
        case 1:
            rateImage.image = RateImages.rateOne
        case 2:
            rateImage.image = RateImages.rateTwo
        case 3:
            rateImage.image = RateImages.rateThree
        case 4:
            rateImage.image = RateImages.rateFour
        case 5:
            rateImage.image = RateImages.rateFive
        default:
            break
        }
    }
    
    // MARK: - Methods
    
    func setupCellData(_ model: NFTCell) {
        self.model = model
        nameLabel.text = model.name
        setRateImage(model.rating)
        fromLabel.text = model.author
        priceLabel.text = "\(model.price) ETH"
        
        if model.isLiked {
            likeButton.setImage(UIImage(named: "liked"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "unliked"), for: .normal)
        }
        
        guard let firstImage = model.images.first,
              let imageUrl = URL(string: firstImage) else { return }
        imageView.kf.setImage(with: imageUrl)
    }
}

// MARK: - ReuseIdentifying

extension MyNFTCollectionViewCell: ReuseIdentifying {
    static let defaultReuseIdentifier = "MyNFTCell"
}
