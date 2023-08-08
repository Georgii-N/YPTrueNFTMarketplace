
import UIKit

protocol CartMainCellDelegate: AnyObject {
    func didTapDeleteButton(in cell: CartMainCell, idNft: String)
}

final class CartMainCell: UICollectionViewCell {
    
    // MARK: Public dependencies
    weak var delegate: CartMainCellDelegate?
    var idNft: String?
    
    // MARK: UI constants and variables
    lazy var imageNFT: UIImageView = {
        let imageNFT = UIImageView()
        imageNFT.layer.masksToBounds = true
        imageNFT.layer.cornerRadius = 12
        return imageNFT
    }()
    
    lazy var nameNFT: UILabel = {
        let nameNFT = UILabel()
        nameNFT.textColor = .blackDay
        nameNFT.font = UIFont.boldSystemFont(ofSize: 17)
        return nameNFT
    }()
    
    lazy var ratingNFT: UIImageView = {
        let ratingNFT = UIImageView()
        // ratingNFT.image = UIImage(named: "mokRatingNFT")
        return ratingNFT
    }()
    
    lazy var priceNFT: UILabel = {
        let priceNFT = UILabel()
        priceNFT.textColor = .blackDay
        priceNFT.font = UIFont.systemFont(ofSize: 13)
        priceNFT.text = "Цена"
        return priceNFT
    }()
    
    lazy var priceCountNFT: UILabel = {
        let priceCountNFT = UILabel()
        priceCountNFT.textColor = .blackDay
        priceCountNFT.font = UIFont.boldSystemFont(ofSize: 17)
        return priceCountNFT
    }()
    
    lazy var deleteCartButton: UIButton = {
        let deleteCartButton = UIButton()
        deleteCartButton.setImage(UIImage(named: "removeBasket"), for: .normal)
        return deleteCartButton
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
            deleteCartButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 34),
            deleteCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private  func setTargets() {
        deleteCartButton.addTarget(self, action: #selector(openDeleteAlert), for: .touchUpInside)
    }
    
    // MARK: Methods
    func setRating(rating: Int) {
        switch rating {
        case 0: ratingNFT.image = UIImage(named: "rating_0")
        case 1: ratingNFT.image = UIImage(named: "rating_1")
        case 2: ratingNFT.image = UIImage(named: "rating_2")
        case 3: ratingNFT.image = UIImage(named: "rating_3")
        case 4: ratingNFT.image = UIImage(named: "rating_4")
        case 5: ratingNFT.image = UIImage(named: "rating_5")
        default: break
        }
    }
    
    @objc
    private func openDeleteAlert() {
        guard let id = idNft else { return }
        delegate?.didTapDeleteButton(in: self, idNft: id)
    }
}

extension CartMainCell: ReuseIdentifying {
    static var defaultReuseIdentifier = "cellCart"
}
