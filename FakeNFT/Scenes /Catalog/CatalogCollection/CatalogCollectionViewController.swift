//
//  CatalogCollectionViewController.swift
//  FakeNFT
//
//  Created by Евгений on 31.07.2023.
//

import UIKit

final class CatalogCollectionViewController: UIViewController {
    
    // MARK: - Private Dependencies:
    private var viewModel: CatalogCollectionViewModelProtocol?
    
    // MARK: - UI:
    private lazy var collectionScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 500)
        
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
        
        return label
    }()
    
    private lazy var authorLinkTextView: UITextView = {
        let textView = UITextView()
        let attributeString = NSMutableAttributedString(string: "John Doe")
        let link = viewModel?.aboutAuthorURLString ?? ""
        attributeString.addAttribute(.link, value: link, range: NSRange(location: 0, length: attributeString.length))
        textView.attributedText = attributeString
        textView.contentInset = UIEdgeInsets(top: -9, left: 0, bottom: 0, right: 0)
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
        setupTargets()
        
        setupNFTInfo()
    }
    
    init(viewModel: CatalogCollectionViewModelProtocol?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func setupCoverNFTImage(image: UIImage) {
        viewModel?.setCurrentNFTImage(image: image)
    }
    
    // MARK: - Private Methods:
    private func setupNFTInfo() {
        guard let viewModel = viewModel else { return }
        
        coverNFTImageView.image = viewModel.coverNFTImage
        nameOfNFTCollectionLabel.text = viewModel.nameOfNFTCollection
        aboutAuthorLabel.text = viewModel.aboutAuthor
        collectionInformationLabel.text = viewModel.collectionInformation
    }
    
    private func switchToNFTCardViewController() {
        let nftViewModel = NFTCardViewModel()
        let viewController = NFTCardViewController(viewModel: nftViewModel)
        
        navigationController?.pushViewController(viewController, animated: true)
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
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NFTCollectionCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        
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
//        guard let cell = collectionView.cellForItem(at: indexPath) as? NFTCollectionCell else { return }
        
        switchToNFTCardViewController()
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
            authorLinkTextView.bottomAnchor.constraint(equalTo: aboutAuthorLabel.bottomAnchor),
            
            collectionInformationLabel.topAnchor.constraint(equalTo: aboutAuthorLabel.bottomAnchor, constant: 5),
            collectionInformationLabel.leadingAnchor.constraint(equalTo: collectionScrollView.leadingAnchor, constant: 16),
            collectionInformationLabel.trailingAnchor.constraint(equalTo: collectionScrollView.trailingAnchor, constant: -16),
            
            nftCollection.widthAnchor.constraint(equalToConstant: view.frame.width),
            nftCollection.heightAnchor.constraint(equalToConstant: 800),
            nftCollection.topAnchor.constraint(equalTo: collectionInformationLabel.bottomAnchor),
            nftCollection.leadingAnchor.constraint(equalTo: collectionScrollView.leadingAnchor),
            nftCollection.trailingAnchor.constraint(equalTo: collectionScrollView.trailingAnchor),
            nftCollection.bottomAnchor.constraint(equalTo: collectionScrollView.bottomAnchor)
        ])
    }
}

// MARK: - Setup Targets:
extension CatalogCollectionViewController {
    private func setupTargets() {
    }
}
