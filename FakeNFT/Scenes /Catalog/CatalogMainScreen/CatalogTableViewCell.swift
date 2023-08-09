//
//  CatalogTableViewCell.swift
//  FakeNFT
//
//  Created by Евгений on 31.07.2023.
//

import UIKit
import Kingfisher

final class CatalogTableViewCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - Public Properties:
    static var defaultReuseIdentifier = "CatalogTableViewCell"
    
    // MARK: - Constants and Variables:
    private var collection: NFTCollection? {
        didSet {
            guard let collection = collection else { return }
            let widht = isLargeScreen() ? UIScreen.main.bounds.width : contentView.frame.width * 1.15
            let size = CGSize(width: widht, height: 140)
            let url = URL(string: collection.cover.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            let processor = DownsamplingImageProcessor(size: size) |> RoundCornerImageProcessor(cornerRadius: 12)
            contentNFTImageView.kf.indicatorType = .activity
            contentNFTImageView.kf.setImage(with: url, options: [.processor(processor),
                                                                 .transition(.fade(1)),
                                                                 .cacheOriginalImage])
            nameOfNFTCollectionLabel.text = collection.name + " (\(collection.nfts.count))"
        }
    }
    
    // MARK: - UI:
    private lazy var contentNFTImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .lightGrayDay
        imageView.contentMode = .top
        
        return imageView
    }()
    
    private lazy var nameOfNFTCollectionLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 17)
        
        return label
    }()
    
    // MARK: - lifecycle:
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .whiteDay
        selectionStyle = .none
        layer.masksToBounds = true
        
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Public Methods:
    func setupCollectionModel(model: NFTCollection) {
        collection = model
    }
    
    func getCollectionModel() -> NFTCollection {
        collection ?? NFTCollection(createdAt: "", name: "", cover: "", nfts: [], description: "", author: "", id: "")
    }
    
    // MARK: - Private Methods:
    private func isLargeScreen() -> Bool {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let maxSize = max(screenWidth, screenHeight)
        
        return maxSize >= 896
    }
}

// MARK: - Setup Views:
extension CatalogTableViewCell {
    private func setupViews() {
        contentView.setupView(contentNFTImageView)
        contentView.setupView(nameOfNFTCollectionLabel)
    }
}

// MARK: - Setup Constraints:
extension CatalogTableViewCell {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentNFTImageView.heightAnchor.constraint(equalToConstant: 140),
            contentNFTImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentNFTImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentNFTImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameOfNFTCollectionLabel.topAnchor.constraint(equalTo: contentNFTImageView.bottomAnchor, constant: 4),
            nameOfNFTCollectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)])
    }
}
