//
//  NFTCardTableViewCell.swift
//  FakeNFT
//
//  Created by Евгений on 03.08.2023.
//

import UIKit
import Kingfisher

final class NFTCardTableViewCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - Constant and Variables:
    private var сurrency: Currency? {
        didSet {
            let size = CGSize(width: 32, height: contentView.frame.height - 36)
            let processor = DownsamplingImageProcessor(size: size)
            
            if let url = URL(string: сurrency?.image ?? "") {
                nftImageView.kf.indicatorType = .activity
                nftImageView.kf.setImage(with: url,
                                         options: [.processor(processor),
                                                   .transition(.fade(1))])
                let name = сurrency?.name ?? ""
                let title = сurrency?.title ?? ""
                nftNameLabel.text = title + " (\(name))"
                nftDepositLabel.text = "0.1 (\(name))"
            }
        }
    }
    
    // MARK: - UI:
    private lazy var mainCellImageView = UIImageView()
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.backgroundColor = .blackUniversal
        
        return imageView
    }()
    
    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .blackDay
        
        return label
    }()
    
    private lazy var nftPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .blackDay
        label.text = "$18.11"
        
        return label
    }()
    
    private lazy var nftDepositLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .greenUniversal
        label.text = "$18.11"
        
        return label
    }()
    
    private lazy var nftDetailButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "chevron.forward")
        button.setImage(image, for: .normal)
        button.tintColor = .blackDay
        
        return button
    }()
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .lightGrayDay
        
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Public Methods:
    func setupСurrencyModel(model: Currency) {
        сurrency = model
    }
}

// MARK: - Setup Views:
extension NFTCardTableViewCell {
    private func setupViews() {
        contentView.setupView(mainCellImageView)
        
        mainCellImageView.setupView(nftImageView)
        mainCellImageView.setupView(nftNameLabel)
        mainCellImageView.setupView(nftPriceLabel)
        mainCellImageView.setupView(nftDepositLabel)
        mainCellImageView.setupView(nftDetailButton)
    }
}

// MARK: - Setup Constraints:
extension NFTCardTableViewCell {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainCellImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainCellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainCellImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            mainCellImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            nftImageView.widthAnchor.constraint(equalToConstant: 32),
            nftImageView.topAnchor.constraint(equalTo: mainCellImageView.topAnchor, constant: 2),
            nftImageView.leadingAnchor.constraint(equalTo: mainCellImageView.leadingAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: mainCellImageView.bottomAnchor, constant: -2),
            
            nftNameLabel.topAnchor.constraint(equalTo: mainCellImageView.topAnchor),
            nftNameLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 10),
            
            nftPriceLabel.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 1),
            nftPriceLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 10),
            nftPriceLabel.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 1),
            nftPriceLabel.bottomAnchor.constraint(equalTo: mainCellImageView.bottomAnchor),
            
            nftDepositLabel.centerYAnchor.constraint(equalTo: mainCellImageView.centerYAnchor),
            nftDepositLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            nftDetailButton.heightAnchor.constraint(equalToConstant: 14),
            nftDetailButton.widthAnchor.constraint(equalToConstant: 8),
            nftDetailButton.centerYAnchor.constraint(equalTo: mainCellImageView.centerYAnchor),
            nftDetailButton.trailingAnchor.constraint(equalTo: mainCellImageView.trailingAnchor)
        ])
    }
}
