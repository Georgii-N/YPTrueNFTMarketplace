//
//  NFTRatingStackView.swift
//  FakeNFT
//
//  Created by Евгений on 15.08.2023.
//

import UIKit

final class NFTRatingStackView: UIStackView {
    
    // MARK: - Lifecycle:
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods:
    func setupNFTRating(with rating: Int) {
        (1...5).forEach { [weak self] number in
            guard let self = self else { return }
            
            if number <= rating {
                let goldStar = UIImageView(image: Resources.Images.NFTCollectionCell.goldRatingStar)
                self.addArrangedSubview(goldStar)
            } else {
                let grayStar = UIImageView(image: Resources.Images.NFTCollectionCell.grayRatingStar)
                self.addArrangedSubview(grayStar)
            }
        }
    }
}

// MARK: - Setup Views:
extension NFTRatingStackView {
    private func setupStackView() {
       axis = .horizontal
       spacing = 2
       distribution = .fillEqually
    }
}
