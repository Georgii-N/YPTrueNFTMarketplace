import UIKit
import Kingfisher

final class NFTCollectionCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Constants and Variables:
    private var nftModel: NFTCard? {
        didSet {
            guard let nftModel = nftModel else { return }
            let urlString = nftModel.images[0]
            let size = CGSize(width: contentView.frame.width, height: 108)
            let processor = DownsamplingImageProcessor(size: size) |> RoundCornerImageProcessor(cornerRadius: 12)
            if let url = URL(string: urlString) {
                nftImageView.kf.indicatorType = .activity
                nftImageView.kf.setImage(with: url,
                                         options: [.processor(processor),
                                                   .transition(.fade(1)),
                                                   .cacheOriginalImage])
                nftNameLabel.text = nftModel.name
                nftPriceLabel.text = "(\(nftModel.price) ETH)"
                setupRatingStackView(rating: nftModel.rating)
            }
        }
    }
    
    // MARK: UI:
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
        
        return label
    }()
    
    private lazy var nftPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .blackDay
        
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
    func setupNFTModel(model: NFTCard) {
        nftModel = model
    }
    
    // MARK: - Private Methods:
    private func setupRatingStackView(rating: Int) {
        (1...5).forEach { [weak self] number in
            guard let self = self else { return }
            
            if number <= rating {
                let goldStar = UIImageView(image: Resources.Images.NFTCollectionCell.goldRatingStar)
                self.ratingStackView.addArrangedSubview(goldStar)
            } else {
                let grayStar = UIImageView(image: Resources.Images.NFTCollectionCell.grayRatingStar)
                self.ratingStackView.addArrangedSubview(grayStar)
            }
        }
    }
    
    // MARK: - Objc Methods:
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
                
        [nftImageView, nftLikeButton, ratingStackView, nftNameLabel,
         nftPriceLabel, cartImageView, cartButton].forEach(contentView.setupView)
        
        nftImageView.setupView(nftLikeImageView)
    }
}

// MARK: - Setup Constraints:
extension NFTCollectionCell {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            nftLikeImageView.heightAnchor.constraint(equalToConstant: 40),
            nftLikeImageView.widthAnchor.constraint(equalToConstant: 40),
            nftLikeImageView.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            nftLikeImageView.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            
            nftLikeButton.heightAnchor.constraint(equalToConstant: 18),
            nftLikeButton.widthAnchor.constraint(equalToConstant: 22),
            nftLikeButton.centerXAnchor.constraint(equalTo: nftLikeImageView.centerXAnchor),
            nftLikeButton.centerYAnchor.constraint(equalTo: nftLikeImageView.centerYAnchor),
            
            ratingStackView.heightAnchor.constraint(equalToConstant: 12),
            ratingStackView.widthAnchor.constraint(equalToConstant: 68),
            ratingStackView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            ratingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            nftNameLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 5),
            nftNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            nftPriceLabel.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 4),
            nftPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            cartImageView.heightAnchor.constraint(equalToConstant: 40),
            cartImageView.widthAnchor.constraint(equalToConstant: 40),
            cartImageView.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 4),
            cartImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
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
