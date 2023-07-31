//
//  CatalogTableViewCell.swift
//  FakeNFT
//
//  Created by Евгений on 31.07.2023.
//

import UIKit

final class CatalogTableViewCell: UITableViewCell, ReuseIdentifying {
    private lazy var contentNFTImageView = UIImageView()
    private lazy var nameOfNFTCollectionLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 17)
        
        return label
    }()
    
    static var defaultReuseIdentifier = "CatalogTableViewCell"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectionStyle = .none
        layer.cornerRadius = 12
        
        setupViews()
        setupConstraints()
    }
    
    func setupContentImage(_ image: UIImage) {
        contentNFTImageView.image = image
    }
    
    func setupLabelText(text: String) {
        nameOfNFTCollectionLabel.text = text
    }
}

// MARK: Setup Views:
extension CatalogTableViewCell {
    private func setupViews() {
        contentView.setupView(contentNFTImageView)
        contentView.setupView(nameOfNFTCollectionLabel)
    }
}

// MARK: Setup Constraints:
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
