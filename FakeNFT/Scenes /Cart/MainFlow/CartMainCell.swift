import UIKit
import Kingfisher

protocol CartMainCellDelegate: AnyObject {
    func didTapDeleteButton(in image: UIImage, idNft: String)
}

final class CartMainCell: UICollectionViewCell {
    
    // MARK: Public dependencies
    weak var delegate: CartMainCellDelegate?
    var idNft: String?
    
    // MARK: UI constants and variables
   private lazy var imageNFT: UIImageView = {
        let imageNFT = UIImageView()
        imageNFT.layer.masksToBounds = true
        imageNFT.layer.cornerRadius = 12
        return imageNFT
    }()
    
    private lazy var nameNFT: UILabel = {
        let nameNFT = UILabel()
        nameNFT.textColor = .blackDay
        nameNFT.font = UIFont.boldSystemFont(ofSize: 17)
        return nameNFT
    }()
    
    private lazy var ratingNFT: UIImageView = {
        let ratingNFT = UIImageView()
        return ratingNFT
    }()
    
    private lazy var priceNFT: UILabel = {
        let priceNFT = UILabel()
        priceNFT.textColor = .blackDay
        priceNFT.font = UIFont.systemFont(ofSize: 13)
        priceNFT.text = "Цена"
        return priceNFT
    }()
    
    private lazy var priceCountNFT: UILabel = {
        let priceCountNFT = UILabel()
        priceCountNFT.textColor = .blackDay
        priceCountNFT.font = UIFont.boldSystemFont(ofSize: 17)
        return priceCountNFT
    }()
    
    private lazy var deleteCartButton: UIButton = {
        let deleteCartButton = UIButton()
        deleteCartButton.setImage(Resources.Images.NFTCollectionCell.removeFromBasket, for: .normal)
        return deleteCartButton
    }()
    
    private lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        return formatter
    }()
    
    // MARK: - Lifecycle:
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Set Up UI
extension CartMainCell {
    private func setupViews() {
        [imageNFT, nameNFT, ratingNFT, priceNFT, priceCountNFT, deleteCartButton].forEach(contentView.setupView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageNFT.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageNFT.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameNFT.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            nameNFT.leadingAnchor.constraint(equalTo: imageNFT.trailingAnchor, constant: 20),
            ratingNFT.topAnchor.constraint(equalTo: nameNFT.bottomAnchor, constant: 4),
            ratingNFT.leadingAnchor.constraint(equalTo: imageNFT.trailingAnchor, constant: 20),
            priceNFT.topAnchor.constraint(equalTo: ratingNFT.bottomAnchor, constant: 12),
            priceNFT.leadingAnchor.constraint(equalTo: imageNFT.trailingAnchor, constant: 20),
            priceCountNFT.topAnchor.constraint(equalTo: priceNFT.bottomAnchor, constant: 2),
            priceCountNFT.leadingAnchor.constraint(equalTo: imageNFT.trailingAnchor, constant: 20),
            deleteCartButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private  func setTargets() {
        deleteCartButton.addTarget(self, action: #selector(openDeleteAlert), for: .touchUpInside)
    }
    
    // MARK: Methods
    private func setRating(rating: Int) {
        guard rating < 6 else {
            return
        }
        return ratingNFT.image = UIImage(named: "rating_\(rating)")
    }
    
    func setupCollectionModel(model: NFTCard) {
        let imageUrl = URL(string: model.images[0])
        let size = CGSize(width: 115, height: 115)
        let resizingProcessor = ResizingImageProcessor(referenceSize: size)
        nameNFT.text = model.name
        if let formattedString = formatter.string(from: NSNumber(value: model.price)) {
            priceCountNFT.text = "\(String(formattedString)) ETH"
        }
        imageNFT.kf.setImage(with: imageUrl, options: [.processor(resizingProcessor)])
        setRating(rating: model.rating)
        idNft = model.id
    }
    
    @objc
    private func openDeleteAlert() {
        guard let id = idNft,
        let image = imageNFT.image else { return }
        delegate?.didTapDeleteButton(in: image, idNft: id)
    }
}

extension CartMainCell: ReuseIdentifying {
    static var defaultReuseIdentifier = "cellCart"
}
