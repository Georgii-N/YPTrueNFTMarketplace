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
    
    // MARK: - UI:
    private lazy var collectionScrollView: UIScrollView = {
        let scrollView = UIScrollView()
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
        textView.textAlignment = .center
        textView.backgroundColor = .whiteDay
        textView.dataDetectorTypes = .link
        textView.delegate = self
        textView.isEditable = false
        textView.isSelectable = true
        textView.font = .systemFont(ofSize: 15)
        textView.textColor = .blueUniversal
        
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
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        setupCollectionInfo()
        bind()
    }
    
    init(viewModel: CatalogCollectionViewModelProtocol?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods:
    private func bind() {
        viewModel?.collectionObservable.bind(action: { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.setupCollectionInfo()
            }
        })
        
        viewModel?.authorCollectionObservable.bind(action: { [weak self] author in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.setupAuthorInfo(authorModel: author)
            }
        })
        
        viewModel?.nftsObservable.bind(action: { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.nftCollection.reloadData()
            }
        })
        
        viewModel?.likeStatusDidChangeObservable.bind(action: { [weak self] _ in
            DispatchQueue.main.async {
            guard let self = self,
                  let indexPathToUpdateNFTCell = self.indexPathToUpdateNFTCell,
                  let cell = self.nftCollection.cellForItem(at: indexPathToUpdateNFTCell) as? NFTCollectionCell,
                  let nftModel = cell.getNFTModel() else { return }
            let newModel = NFTCell(name: nftModel.name,
                                   images: nftModel.images,
                                   rating: nftModel.rating,
                                   price: nftModel.price,
                                   author: nftModel.author,
                                   id: nftModel.id,
                                   isLiked: !nftModel.isLiked,
                                   isAddedToCard: false)
                cell.setupNFTModel(model: newModel)
                
                self.indexPathToUpdateNFTCell = nil
            }
        })
    }
    
    // Setup NFT's info:
    private func setupCollectionInfo() {

        guard let collectionModel = viewModel?.collectionObservable.wrappedValue else { return }
       
        setNFTCollectionImage(model: collectionModel)
        nameOfNFTCollectionLabel.text = collectionModel.name
        collectionInformationLabel.text = collectionModel.description
    }
    
    private func setupAuthorInfo(authorModel: UserResponse?) {
        guard let author = authorModel,
              let link = author.website.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let attributeString = NSMutableAttributedString(string: author.name)
        attributeString.addAttribute(.link, value: link, range: NSRange(location: 0, length: attributeString.length))
        authorLinkTextView.attributedText = attributeString
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
        guard let collection = viewModel?.collectionObservable.wrappedValue,
              let nfts = viewModel?.nftsObservable.wrappedValue else { return }
    
        let nftViewModel = NFTCardViewModel(nfts: nfts, nftModel: nftModel, nftCollection: collection)
        let viewController = NFTCardViewController(viewModel: nftViewModel)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - NFTCollectionCellDelegate:
extension CatalogCollectionViewController: NFTCollectionCellDelegate {
    func likeButtonDidTapped(cell: NFTCollectionCell) {
        guard let model = cell.getNFTModel(),
              let indexPath = nftCollection.indexPath(for: cell) else { return }
        
        let modelID = model.id
        
        viewModel?.changeNFTFavouriteStatus(isLiked: model.isLiked, id: modelID)
        indexPathToUpdateNFTCell = indexPath
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
            cell.setupNFTModel(model: nftModel)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CatalogCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 108, height: 172)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let nftModel = viewModel?.nftsObservable.wrappedValue?[indexPath.row] else { return }
        switchToNFTCardViewController(nftModel: nftModel)
    }
}

// MARK: - Setup Views:
extension CatalogCollectionViewController {
    private func setupViews() {
        view.backgroundColor = .whiteDay
        navigationController?.navigationBar.backgroundColor = .clear
        
        view.setupView(collectionScrollView)
        collectionScrollView.setupView(coverNFTImageView)
        collectionScrollView.setupView(nameOfNFTCollectionLabel)
        collectionScrollView.setupView(aboutAuthorLabel)
        collectionScrollView.setupView(authorLinkTextView)
        collectionScrollView.setupView(collectionInformationLabel)
        collectionScrollView.setupView(nftCollection)
    }
}

// MARK: - Setup Constraints:
extension CatalogCollectionViewController {
    private func setupConstraints() {
        
        let collectionItems = viewModel?.collectionObservable.wrappedValue.nfts.count ?? 0
        let collectionHeight = collectionItems % 3 == 0 ? (collectionItems / 3 * 182) + 24 : (collectionItems / 3 * 182) + 204
        
        NSLayoutConstraint.activate([
            collectionScrollView.topAnchor.constraint(equalTo: view.topAnchor),
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
