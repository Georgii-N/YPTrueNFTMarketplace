//
//  CatalogCollectionViewController.swift
//  FakeNFT
//
//  Created by Евгений on 31.07.2023.
//

import UIKit
import Kingfisher

final class CatalogCollectionViewController: UIViewController {
    
    // MARK: - Private Dependencies:
    private var viewModel: CatalogCollectionViewModelProtocol?
    
    // MARK: - Constant and Variables:
    private var indexPathToUpdateNFTCell: IndexPath?
    private lazy var refreshControl = UIRefreshControl()
    
    // MARK: - UI:
    private lazy var collectionScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        
        return scrollView
    }()
    
    private lazy var coverNFTImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        return imageView
    }()
    
    private lazy var nameOfNFTCollectionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blackDay
        label.font = .boldSystemFont(ofSize: 22)
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var aboutAuthorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blackDay
        label.font = .systemFont(ofSize: 13)
        label.text = L10n.Catalog.CurrentCollection.author
        
        return label
    }()
    
    private lazy var authorLinkTextView: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0)
        textView.dataDetectorTypes = .link
        textView.textContainer.lineFragmentPadding = 0
        textView.delegate = self
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false 
        textView.font = .systemFont(ofSize: 15)
        textView.textColor = .blueUniversal
        textView.backgroundColor = .whiteDay
        
        return textView
    }()
    
    private lazy var collectionInformationLabel: UILabel = {
        let text = UILabel()
        text.numberOfLines = 0
        text.font = .systemFont(ofSize: 13)
        text.textColor = .blackDay
        
        return text
    }()
    
    private lazy var nftCollection: NFTCollectionView = {
        let collection = NFTCollectionView()
        collection.isScrollEnabled = false
        collection.dataSource = self
        collection.delegate = self
        
        return collection
    }()
    
    // MARK: - Lifecycle:
    init(viewModel: CatalogCollectionViewModelProtocol?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blockUI()
        
        setupViews()
        setupConstraints()
        setupTargets()
        
        setupCollectionInfo()
        bind()
    }
    
    // MARK: - Private Methods:
    private func bind() {
        viewModel?.collectionObservable.bind(action: { [weak self] _ in
            guard let self = self else { return }
            self.resumeMethodOnMainThread(self.setupCollectionInfo, with: ())
        })
        
        self.viewModel?.authorCollectionObservable.bind(action: { [weak self] author in
            guard let self = self else { return }
            self.resumeMethodOnMainThread(self.setupAuthorInfo, with: author)
        })
        
        viewModel?.nftsObservable.bind(action: { [weak self] _ in
            guard let self = self else { return }
            self.resumeMethodOnMainThread(self.nftCollection.reloadData, with: ())
        })
        
        viewModel?.likeStatusDidChangeObservable.bind(action: { [weak self] _ in
            guard let self = self else { return }
            self.resumeMethodOnMainThread(self.unblockUI, with: ())
            self.resumeMethodOnMainThread(self.changeCellStatus, with: true)
        })
        
        viewModel?.cartStatusDidChangeObservable.bind(action: { [weak self] _ in
            guard let self = self else { return }
            self.resumeMethodOnMainThread(self.unblockUI, with: ())
            self.resumeMethodOnMainThread(self.changeCellStatus, with: false)
        })
    }
    
    // Setup NFT's info:
    private func setupCollectionInfo() {
        guard let collectionModel = self.viewModel?.collectionObservable.wrappedValue else { return }
        
        setNFTCollectionImage(model: collectionModel)
        nameOfNFTCollectionLabel.text = collectionModel.name
        collectionInformationLabel.text = collectionModel.description
    }
    
    private func setupAuthorInfo(authorModel: UserResponse?) {
        guard let author = authorModel,
              let link = author.website.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .link: link,
            .font: UIFont.systemFont(ofSize: 15)
        ]
        let attributeString = NSMutableAttributedString(string: author.name, attributes: attributes)
        self.authorLinkTextView.attributedText = attributeString
    }
    
    private func setNFTCollectionImage(model: NFTCollection) {
        guard let urlString = model.cover.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = URL(string: urlString)
        let size = CGSize(width: collectionScrollView.frame.width, height: 310)
        let processor = DownsamplingImageProcessor(
            size: size) |> RoundCornerImageProcessor(cornerRadius: 10)
        
        coverNFTImageView.kf.indicatorType = .activity
        coverNFTImageView.kf.setImage(with: url, options: [.processor(processor), .transition(.fade(1))])
    }
    
    private func switchToNFTCardViewController(nftModel: NFTCell) {
        guard let collection = viewModel?.collectionObservable.wrappedValue else { return }
        
        let nftViewModel = NFTCardViewModel(nftModel: nftModel, nftCollection: collection)
        let viewController = NFTCardViewController(delegate: self, viewModel: nftViewModel)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func changeCellStatus(isLike: Bool) {
        guard let indexPathToUpdateNFTCell = indexPathToUpdateNFTCell,
              let cell = nftCollection.cellForItem(at: indexPathToUpdateNFTCell) as? NFTCollectionCell,
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
    
    private func resumeMethodOnMainThread<T>(_ method: @escaping ((T) -> Void), with argument: T) {
        DispatchQueue.main.async {
            method(argument)
        }
    }
    
    // MARK: Objc Methods:
    @objc private func refreshNFTCollection() {
        viewModel?.updateNFTCardModels()
    }
}

// MARK: - NFTCollectionCellDelegate:
extension CatalogCollectionViewController: NFTCollectionCellDelegate {
    func likeButtonDidTapped(cell: NFTCollectionCell) {
        guard let model = cell.getNFTModel(),
              let indexPath = nftCollection.indexPath(for: cell) else { return }
        blockUI()
        
        let modelID = model.id
        
        viewModel?.changeNFTFavouriteStatus(isLiked: model.isLiked, id: modelID)
        indexPathToUpdateNFTCell = indexPath
    }
    
    func addToCardButtonDidTapped(cell: NFTCollectionCell) {
        guard let model = cell.getNFTModel(),
              let indexPath = nftCollection.indexPath(for: cell) else { return }
        blockUI()
        
        let modelID = model.id
        
        viewModel?.changeNFTCartStatus(isAddedToCart: model.isAddedToCard, id: modelID)
        indexPathToUpdateNFTCell = indexPath
    }
}

// MARK: - NFTCardViewControllerDelegate:
extension CatalogCollectionViewController: NFTCardViewControllerDelegate {
    func addIndexToUpdateCell(index: IndexPath, isLike: Bool) {
        indexPathToUpdateNFTCell = index
        changeCellStatus(isLike: isLike)
    }
    
    func addIndexToUpdateCell(index: IndexPath, isAddedToCart: Bool) {
        guard let cell = nftCollection.cellForItem(at: index) as? NFTCollectionCell else { return }
        
        indexPathToUpdateNFTCell = index
        addToCardButtonDidTapped(cell: cell)
    }
}

// MARK: - UITextViewDelegate
extension CatalogCollectionViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let webViewViewModel = WebViewViewModel()
        let webViewController = WebViewViewController(viewModel: webViewViewModel, url: URL)
        
        navigationController?.pushViewController(webViewController, animated: true)
        
        return false
    }
}

// MARK: - UICollectionViewDataSource
extension CatalogCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let collection = viewModel?.collectionObservable.wrappedValue else { return 0 }
        return collection.nfts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NFTCollectionCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.delegate = self
        
        if let nftModel = viewModel?.nftsObservable.wrappedValue?[indexPath.row] {
            unblockUI()
            cell.setupNFTModel(model: nftModel)
            refreshControl.endRefreshing()
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CatalogCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 108, height: 172)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? NFTCollectionCell,
              let model = cell.getNFTModel() else { return }
        
        switchToNFTCardViewController(nftModel: model)
    }
}

// MARK: - Setup Views:
extension CatalogCollectionViewController {
    private func setupViews() {
        view.backgroundColor = .whiteDay
        
        view.setupView(collectionScrollView)
        
        [coverNFTImageView, nameOfNFTCollectionLabel, aboutAuthorLabel, authorLinkTextView,
         collectionInformationLabel, nftCollection].forEach(collectionScrollView.setupView)
        
        collectionScrollView.refreshControl = refreshControl
    }
}

// MARK: - Setup Constraints:
extension CatalogCollectionViewController {
    private func setupConstraints() {
        
        let collectionItems = viewModel?.collectionObservable.wrappedValue.nfts.count ?? 0
        let collectionHeight = collectionItems % 3 == 0 ? (collectionItems / 3 * 182) + 24 : (collectionItems / 3 * 182) + 204
        
        NSLayoutConstraint.activate([
            collectionScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            coverNFTImageView.heightAnchor.constraint(equalToConstant: 310),
            coverNFTImageView.topAnchor.constraint(equalTo: collectionScrollView.topAnchor),
            coverNFTImageView.leadingAnchor.constraint(equalTo: collectionScrollView.leadingAnchor),
            coverNFTImageView.trailingAnchor.constraint(equalTo: collectionScrollView.trailingAnchor),
            
            nameOfNFTCollectionLabel.topAnchor.constraint(equalTo: coverNFTImageView.bottomAnchor, constant: 16),
            nameOfNFTCollectionLabel.leadingAnchor.constraint(equalTo: collectionScrollView.leadingAnchor, constant: 16),
            
            aboutAuthorLabel.topAnchor.constraint(equalTo: nameOfNFTCollectionLabel.bottomAnchor, constant: 13),
            aboutAuthorLabel.leadingAnchor.constraint(equalTo: collectionScrollView.leadingAnchor, constant: 16),
            
            authorLinkTextView.topAnchor.constraint(equalTo: nameOfNFTCollectionLabel.bottomAnchor, constant: 12),
            authorLinkTextView.leadingAnchor.constraint(equalTo: aboutAuthorLabel.trailingAnchor, constant: 4),
            authorLinkTextView.trailingAnchor.constraint(equalTo: collectionScrollView.trailingAnchor, constant: 16),
            authorLinkTextView.bottomAnchor.constraint(equalTo: aboutAuthorLabel.bottomAnchor, constant: 1),
            
            collectionInformationLabel.topAnchor.constraint(equalTo: aboutAuthorLabel.bottomAnchor, constant: 5),
            collectionInformationLabel.leadingAnchor.constraint(equalTo: collectionScrollView.leadingAnchor, constant: 16),
            collectionInformationLabel.trailingAnchor.constraint(equalTo: collectionScrollView.trailingAnchor, constant: -16),
            
            nftCollection.widthAnchor.constraint(equalToConstant: view.frame.width),
            nftCollection.heightAnchor.constraint(equalToConstant: CGFloat(collectionHeight)),
            nftCollection.topAnchor.constraint(equalTo: collectionInformationLabel.bottomAnchor),
            nftCollection.leadingAnchor.constraint(equalTo: collectionScrollView.leadingAnchor),
            nftCollection.trailingAnchor.constraint(equalTo: collectionScrollView.trailingAnchor),
            nftCollection.bottomAnchor.constraint(equalTo: collectionScrollView.bottomAnchor)
        ])
    }
}

// MARK: - Add Targets:
extension CatalogCollectionViewController {
    private func setupTargets() {
        refreshControl.addTarget(self, action: #selector(refreshNFTCollection), for: .valueChanged)
    }
}
