//
//  NFTCard.swift
//  FakeNFT
//
//  Created by Евгений on 02.08.2023.
//

import UIKit
import Kingfisher

final class NFTCardViewController: UIViewController {
    
    // MARK: - Private Dependencies:
    private var viewModel: NFTCardViewModelProtocol?
    
    // MARK: - UI:
    private lazy var allScreenScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private lazy var contentView = UIView()
    
    private lazy var coverNFTScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        scrollView.contentSize = CGSize(width: view.frame.width*3, height: 375)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.backgroundColor = .gray
        
        return scrollView
    }()
    
    private lazy var coverNFTPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = 3
        pageControl.currentPageIndicatorTintColor = .blackDay
        pageControl.pageIndicatorTintColor = .lightGrayDay
        
        return pageControl
    }()
    
    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .blackDay
        
        return label
    }()
    
    private lazy var nftRatingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .blackDay
        label.text = L10n.General.price
        
        return label
    }()
    
    private lazy var priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .blackDay
        
        return label
    }()
    
    private lazy var nftCollectionNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .blackDay
        
        return label
    }()
    
    private lazy var nftTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.register(NFTCardTableViewCell.self)
        tableView.layer.cornerRadius = 12
        tableView.backgroundColor = .lightGrayDay
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    private lazy var addToCartButton = BaseBlackButton(with: L10n.Catalog.NftCard.Button.addToCart)
    private lazy var sellerWebsiteButton = BaseWhiteButton(with: L10n.Catalog.NftCard.Button.goToSellerSite)
    
    private lazy var nftColectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(NFTCollectionCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    // MARK: Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupTargets()
        
        setupNFTInfo()
        bind()
    }
    
    init(viewModel: NFTCardViewModelProtocol?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods:
    private func bind() {
        viewModel?.nftCollectionObservable.bind(action: { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.setupNFTInfo()
            }
        })
        
        viewModel?.currenciesObservable.bind(action: { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.nftTableView.reloadData()
            }
        })
    }
        
    private func setupNFTInfo() {
        guard let viewModel = viewModel else { return }
        
        let nftModel = viewModel.currentNFTObservable.wrappedValue
        let collection = viewModel.nftCollectionObservable.wrappedValue
        
        nftCollectionNameLabel.text = collection.name
        setupNFTRatingStackView(rating: nftModel.rating)
        nftNameLabel.text = nftModel.name
        priceValueLabel.text = "\(nftModel.price) ETH"
        
        setupCoverScrollView(imagesURL: nftModel.images)
    }
    
    private func setupCoverScrollView(imagesURL: [String]) {
        let imageWidht = view.frame.width
        var images = [UIImageView]()
        
        coverNFTPageControl.numberOfPages = imagesURL.count

        for (index, imageURLString) in imagesURL.enumerated() {
            guard let url = URL(string: imageURLString) else { return }
            let size = CGRect(x: 0, y: 0, width: view.frame.width, height: 375)
            let imageView = UIImageView(frame: CGRect(x: imageWidht * CGFloat(index), y: 0, width: view.frame.width, height: 375))
            let processor = DownsamplingImageProcessor(size: CGSize(width: size.width, height: size.height))

            images.append(imageView)
            coverNFTScrollView.addSubview(images[index])

            images[index].kf.indicatorType = .activity
            images[index].kf.setImage(with: url, options: [.processor(processor), .transition(.fade(1))])
        }
    }
    
    private func setupNFTRatingStackView(rating: Int) {
        (1...5).forEach { [weak self] number in
            guard let self = self else { return }
            
            if number <= rating {
                let goldStar = UIImageView(image: Resources.Images.NFTCollectionCell.goldRatingStar)
                self.nftRatingStackView.addArrangedSubview(goldStar)
            } else {
                let grayStar = UIImageView(image: Resources.Images.NFTCollectionCell.grayRatingStar)
                self.nftRatingStackView.addArrangedSubview(grayStar)
            }
        }
    }
    
    // MARK: Objc Methods:
    @objc private func goToSellerWebSite() {
        guard let url = URL(string: "https://practicum.yandex.ru/ios-developer/") else { return }
        let webViewViewModel = WebViewViewModel()
        let webViewController = WebViewViewController(viewModel: webViewViewModel, url: url)
        
        navigationController?.pushViewController(webViewController, animated: true)
    }
}

// MARK: - UIScrollViewDelegate
extension NFTCardViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x / view.frame.width)
        coverNFTPageControl.currentPage = Int(page)
    }
}

// MARK: - UITableViewDataSource
extension NFTCardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.currenciesObservable.wrappedValue?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        
        let cell: NFTCardTableViewCell = tableView.dequeueReusableCell()
        
        if let currencie = viewModel.currenciesObservable.wrappedValue?[indexPath.row] {
            cell.setupCurrencieModel(model: currencie)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NFTCardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        72
    }
}

// MARK: - UICollectionViewDataSource
extension NFTCardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.nftsObservable.wrappedValue.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NFTCollectionCell = collectionView.dequeueReusableCell(indexPath: indexPath)

        if let nft = viewModel?.nftsObservable.wrappedValue[indexPath.row] {
            cell.setupNFTModel(model: nft)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension NFTCardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 108, height: 172)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
}

// MARK: - Setup Views:
extension NFTCardViewController {
    private func setupViews() {
        view.backgroundColor = .whiteDay
        navigationController?.navigationBar.backgroundColor = .clear
        tabBarController?.tabBar.isHidden = true
        
        view.setupView(allScreenScrollView)
        allScreenScrollView.setupView(contentView)
        
        [coverNFTScrollView, coverNFTPageControl, nftNameLabel, nftRatingStackView,
         priceLabel, priceValueLabel, nftCollectionNameLabel, addToCartButton,
         nftTableView, sellerWebsiteButton, nftColectionView].forEach(contentView.setupView)
    }
}

// MARK: - Setup Constraints:
extension NFTCardViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            allScreenScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            allScreenScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            allScreenScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            allScreenScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: allScreenScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: allScreenScrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: allScreenScrollView.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: allScreenScrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: allScreenScrollView.widthAnchor),
            
            coverNFTScrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverNFTScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverNFTScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverNFTScrollView.heightAnchor.constraint(equalToConstant: 375),
            
            coverNFTPageControl.topAnchor.constraint(equalTo: coverNFTScrollView.bottomAnchor, constant: 12),
            coverNFTPageControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            coverNFTPageControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            coverNFTPageControl.heightAnchor.constraint(equalToConstant: 4),
            
            nftNameLabel.topAnchor.constraint(equalTo: coverNFTPageControl.bottomAnchor, constant: 16),
            nftNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            nftRatingStackView.leadingAnchor.constraint(equalTo: nftNameLabel.trailingAnchor, constant: 8),
            nftRatingStackView.centerYAnchor.constraint(equalTo: nftNameLabel.centerYAnchor),
            nftRatingStackView.widthAnchor.constraint(equalToConstant: 68),
            nftRatingStackView.heightAnchor.constraint(equalToConstant: 12),
            
            priceLabel.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 24),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            priceLabel.heightAnchor.constraint(equalToConstant: 20),
            
            priceValueLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor),
            priceValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            priceValueLabel.heightAnchor.constraint(equalToConstant: 22),
            
            nftCollectionNameLabel.topAnchor.constraint(equalTo: coverNFTPageControl.bottomAnchor, constant: 19),
            nftCollectionNameLabel.centerYAnchor.constraint(equalTo: nftNameLabel.centerYAnchor),
            nftCollectionNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            addToCartButton.topAnchor.constraint(equalTo: priceLabel.topAnchor),
            addToCartButton.bottomAnchor.constraint(equalTo: priceValueLabel.bottomAnchor),
            addToCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            addToCartButton.widthAnchor.constraint(equalToConstant: 240),
            
            nftTableView.heightAnchor.constraint(equalToConstant: 576),
            nftTableView.topAnchor.constraint(equalTo: addToCartButton.bottomAnchor, constant: 24),
            nftTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            sellerWebsiteButton.topAnchor.constraint(equalTo: nftTableView.bottomAnchor, constant: 24),
            sellerWebsiteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sellerWebsiteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            nftColectionView.heightAnchor.constraint(equalToConstant: 172),
            nftColectionView.topAnchor.constraint(equalTo: sellerWebsiteButton.bottomAnchor, constant: 36),
            nftColectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftColectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50),
            nftColectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

// MARK: - Setup Targets:
extension NFTCardViewController {
    private func setupTargets() {
        sellerWebsiteButton.addTarget(self, action: #selector(goToSellerWebSite), for: .touchUpInside)
    }
}
