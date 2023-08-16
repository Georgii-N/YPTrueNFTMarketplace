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
    weak private var delegate: NFTCardViewControllerDelegate?
    private var viewModel: NFTCardViewModelProtocol?
    
    // MARK: - Private Classes:
    private let analyticsService = AnalyticsService.instance
    
    // MARK: - Constant and Variables:
    private var indexPathToUpdateNFTCell: IndexPath?
    private lazy var refreshControl = UIRefreshControl()
    
    // MARK: - UI:
    private lazy var allScreenScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private lazy var contentView = UIView()
    
    private lazy var coverNFTScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        scrollView.contentSize = CGSize(width: view.frame.width * 3, height: 375)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.backgroundColor = .lightGrayDay
        
        return scrollView
    }()
        
    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.font = .headlineMedium
        label.textColor = .blackDay
        
        return label
    }()
        
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .captionSmallRegular
        label.textColor = .blackDay
        label.text = L10n.General.price
        
        return label
    }()
    
    private lazy var priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = .captionMediumBold
        label.textColor = .blackDay
        
        return label
    }()
    
    private lazy var nftCollectionNameLabel: UILabel = {
        let label = UILabel()
        label.font = .headlineSmall
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
    
    private lazy var addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .captionMediumBold
        button.setTitleColor(.whiteDay, for: .normal)
        button.backgroundColor = .blackDay
        
        return button
    }()
    
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
    
    private lazy var sellerWebsiteButton = BaseWhiteButton(with: L10n.Catalog.NftCard.Button.goToSellerSite)
    private lazy var nftRatingStackView = NFTRatingStackView()
    private lazy var refreshStubLabel = RefreshStubLabel()
    private lazy var coverNFTPageControlView = CustomPageControlView()
    
    // MARK: Lifecycle:
    init(delegate: NFTCardViewControllerDelegate?, viewModel: NFTCardViewModelProtocol?) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.viewModel = viewModel
        blockUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupTargets()
        setupGesture()
        
        setupNFTInfo()
        bind()
        
        viewModel?.updateNFTCardModels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsService.sentEvent(screen: .nftCard, item: .screen, event: .open)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.sentEvent(screen: .nftCard, item: .screen, event: .close)
    }
    
    // MARK: - Private Methods:
    private func bind() {
        viewModel?.currenciesObservable.bind { [weak self] _ in
            guard let self else { return }
            self.resumeMethodOnMainThread(self.nftTableView.reloadData, with: ())
        }
        
        viewModel?.nftsObservable.bind { [weak self] _ in
            guard let self else { return }
            self.resumeMethodOnMainThread(self.nftColectionView.reloadData, with: ())
            self.resumeMethodOnMainThread(self.unblockUI, with: ())
            self.resumeMethodOnMainThread(self.refreshControl.endRefreshing, with: ())
        }
        
        viewModel?.likeStatusDidChangeObservable.bind { [weak self] _ in
            guard let self else { return }
            self.resumeMethodOnMainThread(self.unblockUI, with: ())
            self.resumeMethodOnMainThread(self.changeCellStatus, with: true)
        }
        
        viewModel?.cartStatusDidChangeObservable.bind { [weak self] _ in
            guard let self else { return }
            self.resumeMethodOnMainThread(self.unblockUI, with: ())
            self.resumeMethodOnMainThread(self.changeCellStatus, with: false)
        }
        
        viewModel?.networkErrorObservable.bind { [weak self] errorText in
            guard let self else { return }
            if let errorText {
                self.resumeMethodOnMainThread(self.unblockUI, with: ())
                self.resumeMethodOnMainThread(self.refreshControl.endRefreshing, with: ())
                self.resumeMethodOnMainThread(self.showNotificationBanner, with: errorText)
                
                if self.indexPathToUpdateNFTCell != nil {
                    self.saveCellModelAfterError()
                }
            }
        }
    }
    
    // Controll NFT info and status:
    private func setupNFTInfo() {
        guard let viewModel else { return }
        
        let nftModel = viewModel.getCurrentNFTModel()
        let collection = viewModel.getNFTCollection()
        
        nftCollectionNameLabel.text = collection.name
        nftRatingStackView.setupNFTRating(with: nftModel.rating)
        nftNameLabel.text = nftModel.name
        priceValueLabel.text = "\(nftModel.price) ETH"
        
        coverNFTPageControlView.setCurrentState(currentPage: 0, isOnboarding: false)
        setupCoverScrollView(imagesURL: nftModel.images)
    }
    
    private func changeCellStatus(isLike: Bool) {
        guard let indexPathToUpdateNFTCell = self.indexPathToUpdateNFTCell,
              let cell = self.nftColectionView.cellForItem(at: indexPathToUpdateNFTCell) as? NFTCollectionCell,
              let nftModel = cell.getNFTModel() else { return }
        let newModel = NFTCell(name: nftModel.name,
                               images: nftModel.images,
                               rating: nftModel.rating,
                               price: nftModel.price,
                               author: nftModel.author,
                               id: nftModel.id,
                               isLiked: isLike ? !nftModel.isLiked : nftModel.isLiked,
                               isAddedToCard: isLike ? nftModel.isAddedToCard : !nftModel.isAddedToCard)
        cell.setupNFTModel(model: newModel)
        self.indexPathToUpdateNFTCell = nil
    }
    
    private func saveCellModelAfterError() {
        guard let indexPath = indexPathToUpdateNFTCell,
              let cell = nftColectionView.cellForItem(at: indexPath) as? NFTCollectionCell,
              let model = cell.getNFTModel() else { return }
        
        cell.setupNFTModel(model: model)
    }
    
    private func setupCoverScrollView(imagesURL: [String]) {
        let imageWidht = view.frame.width
        var images = [UIImageView]()
                
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
    
    private func setupCartButton() {
        let nftModel = viewModel?.getCurrentNFTModel()
        
        if let isAddedToCard = nftModel?.isAddedToCard {
            let title = isAddedToCard ? L10n.Catalog.NftCard.Button.removeFromCart : L10n.Catalog.NftCard.Button.addToCart
            addToCartButton.setTitle(title, for: .normal)
        }
    }
    
    private func synchronizeCartButtons(id: String, fromCartButton: Bool) {
        let cells = viewModel?.nftsObservable.wrappedValue
        let index = cells?.firstIndex(where: { $0.id == id }) ?? 0
        
        guard let cell = nftColectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? NFTCollectionCell else { return }
        
        if fromCartButton {
            guard let model = cell.getNFTModel() else { return }
            cell.setupNFTModel(model: NFTCell(name: model.name,
                                              images: model.images,
                                              rating: model.rating,
                                              price: model.price,
                                              author: model.author,
                                              id: model.id,
                                              isLiked: model.isLiked,
                                              isAddedToCard: !model.isAddedToCard))
        } else {
            viewModel?.setNewCurrentModel()
        }
        setupCartButton()
    }
    
    private func browsNFTToken(index: Int) {
        let path = viewModel?.getNFTWebPath(index: index) ?? ""
        
        guard let url = URL(string: path) else { return }
        
        let webViewModel = WebViewViewModel()
        let viewController = WebViewViewController(viewModel: webViewModel, url: url)
        
        navigationController?.pushViewController(viewController, animated: true)
        
        analyticsService.sentEvent(screen: .aboutCurrency, item: .screen, event: .open)
    }
    
    private func setupStubLabel() {
        view.setupView(refreshStubLabel)

        NSLayoutConstraint.activate([
        refreshStubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        refreshStubLabel.topAnchor.constraint(equalTo: addToCartButton.bottomAnchor, constant: 100)
        ])
    }
    
    // MARK: Objc Methods:
    @objc private func goToSellerWebSite() {
        let author = viewModel?.getAuthorCollection()
        
        guard let url = URL(string: author?.website ?? "") else { return }
        let webViewViewModel = WebViewViewModel()
        let webViewController = WebViewViewController(viewModel: webViewViewModel, url: url)
        
        navigationController?.pushViewController(webViewController, animated: true)
        
        analyticsService.sentEvent(screen: .nftCard, item: .buttonGoToUserSite, event: .open)
        analyticsService.sentEvent(screen: .catalogAboutAuthorFromNFTCard, item: .screen, event: .open)
    }
    
    @objc private func changeNFTCartStatus() {
        let nftModel = viewModel?.getCurrentNFTModel()
        
        guard let isAddedToCard = nftModel?.isAddedToCard,
              let index = viewModel?.nftsObservable.wrappedValue?.firstIndex(
                where: { $0.id == nftModel?.id }) else { return }
        
        delegate?.addIndexToUpdateCell(index: IndexPath(row: index, section: 0), isAddedToCart: !isAddedToCard)
        viewModel?.setNewCurrentModel()
        synchronizeCartButtons(id: nftModel?.id ?? "", fromCartButton: true)
    }
    
    @objc private func refreshNFTCardScreen() {
        viewModel?.updateNFTCardModels()
        
        analyticsService.sentEvent(screen: .nftCard, item: .pullToRefresh, event: .click)
    }
    
    @objc private func openFullNFTImage() {
        let nftModel = viewModel?.getCurrentNFTModel()
        
        guard let urlStrings = nftModel?.images else { return }
        let viewController = BrowsingNFTViewController(urlStrings: urlStrings)
        
        present(viewController, animated: true)
    }
}

// MARK: - NFTCollectionCellDelegate:
extension NFTCardViewController: NFTCollectionCellDelegate {
    func likeButtonDidTapped(cell: NFTCollectionCell) {
        guard let model = cell.getNFTModel(),
              let indexPath = nftColectionView.indexPath(for: cell) else { return }
        blockUI()
        
        let modelID = model.id
        
        viewModel?.changeNFTFavouriteStatus(isLiked: model.isLiked, id: modelID)
        indexPathToUpdateNFTCell = indexPath
        delegate?.addIndexToUpdateCell(index: indexPath, isLike: true)
        
        analyticsService.sentEvent(screen: .nftCard, item: .buttonLike, event: .click)
    }
    
    func addToCardButtonDidTapped(cell: NFTCollectionCell) {
        guard let model = cell.getNFTModel(),
              let indexPath = nftColectionView.indexPath(for: cell) else { return }
        blockUI()
        
        let modelID = model.id
        
        synchronizeCartButtons(id: modelID, fromCartButton: false)
        viewModel?.changeNFTCartStatus(isAddedToCart: model.isAddedToCard, id: modelID)
        indexPathToUpdateNFTCell = indexPath
        delegate?.addIndexToUpdateCell(index: indexPath, isLike: false)
        
        analyticsService.sentEvent(screen: .nftCard, item: .buttonAddToCard, event: .click)
    }
}

// MARK: - UIScrollViewDelegate
extension NFTCardViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x / view.frame.width)
        coverNFTPageControlView.setCurrentState(currentPage: Int(page), isOnboarding: false)
        
        analyticsService.sentEvent(screen: .nftCard, item: .swipeNFTCard, event: .click)
    }
}

// MARK: - UITableViewDataSource
extension NFTCardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel?.currenciesObservable.wrappedValue == nil {
            setupStubLabel()
        } else {
            refreshStubLabel.removeFromSuperview()
        }
        
        return viewModel?.currenciesObservable.wrappedValue?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel else { return UITableViewCell() }
        
        let cell: NFTCardTableViewCell = tableView.dequeueReusableCell()
        
        if let currency = viewModel.currenciesObservable.wrappedValue?[indexPath.row] {
            cell.setupСurrencyModel(model: currency)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NFTCardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        browsNFTToken(index: indexPath.row)
    }
}

// MARK: - UICollectionViewDataSource
extension NFTCardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.nftsObservable.wrappedValue?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NFTCollectionCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.delegate = self
        
        if let nft = viewModel?.nftsObservable.wrappedValue?[indexPath.row] {
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
        
        setupBackButtonItem()
        
        view.setupView(allScreenScrollView)
        allScreenScrollView.setupView(contentView)
        
        [coverNFTScrollView, coverNFTPageControlView, nftNameLabel, nftRatingStackView,
         priceLabel, priceValueLabel, nftCollectionNameLabel, addToCartButton,
         nftTableView, sellerWebsiteButton, nftColectionView].forEach(contentView.setupView)
        
        setupCartButton()
        allScreenScrollView.refreshControl = refreshControl
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
            
            coverNFTScrollView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            coverNFTScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverNFTScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverNFTScrollView.heightAnchor.constraint(equalToConstant: 375),
            
            coverNFTPageControlView.topAnchor.constraint(equalTo: coverNFTScrollView.bottomAnchor),
            coverNFTPageControlView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverNFTPageControlView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverNFTPageControlView.heightAnchor.constraint(equalToConstant: 28),
            
            nftNameLabel.topAnchor.constraint(equalTo: coverNFTPageControlView.bottomAnchor, constant: 16),
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
            
            nftCollectionNameLabel.topAnchor.constraint(equalTo: coverNFTPageControlView.bottomAnchor, constant: 19),
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
private extension NFTCardViewController {
    func setupTargets() {
        sellerWebsiteButton.addTarget(self, action: #selector(goToSellerWebSite), for: .touchUpInside)
        addToCartButton.addTarget(self, action: #selector(changeNFTCartStatus), for: .touchUpInside)
        refreshControl.addTarget(self, action: #selector(refreshNFTCardScreen), for: .valueChanged)
    }
    
    func setupGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(openFullNFTImage))
        coverNFTScrollView.addGestureRecognizer(gesture)
    }
}
