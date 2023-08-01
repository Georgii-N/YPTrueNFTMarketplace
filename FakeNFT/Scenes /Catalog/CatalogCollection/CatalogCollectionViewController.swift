//
//  CatalogCollectionViewController.swift
//  FakeNFT
//
//  Created by Евгений on 31.07.2023.
//

import UIKit

final class CatalogCollectionViewController: UIViewController {
    
    // MARK: - UI:
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
        let text = UITextView()
        text.isEditable = false
        text.isSelectable = true
        text.font = .systemFont(ofSize: 15)
        text.textColor = .blueUniversal
        
        return text
    }()
    
    private lazy var collectionInformationLabel: UILabel = {
        let text = UILabel()
        text.numberOfLines = 0
        text.font = .systemFont(ofSize: 13)
        text.textColor = .blackDay
        
        return text
    }()
    
    private lazy var nftCollection: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.register(NFTCollectionCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    // MARK: - Public Dependencies:
    var viewModel: CatalogCollectionViewModelProtocol?
    
    // MARK: - Override Methods:
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
        
        let attributedText = NSMutableAttributedString(string: viewModel.author,
                                                       attributes: [NSAttributedString.Key.link: URL(string: "https://practicum.yandex.ru")!])
        
        coverNFTImageView.image = viewModel.coverNFTImage
        nameOfNFTCollectionLabel.text = viewModel.nameOfNFTCollection
        aboutAuthorLabel.text = viewModel.aboutAuthor
        authorLinkTextView.attributedText = attributedText
        collectionInformationLabel.text = viewModel.collectionInformation
    }
}

// MARK: - UICollectionViewDataSource
extension CatalogCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
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
}

// MARK: - Setup Views:
extension CatalogCollectionViewController {
    private func setupViews() {
        view.backgroundColor = .whiteDay
        navigationController?.navigationBar.backgroundColor = .clear
        
        view.setupView(coverNFTImageView)
        view.setupView(nameOfNFTCollectionLabel)
        view.setupView(aboutAuthorLabel)
        view.setupView(authorLinkTextView)
        view.setupView(collectionInformationLabel)
        view.setupView(nftCollection)
    }
}

// MARK: - Setup Constraints:
extension CatalogCollectionViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // NFT image:
            coverNFTImageView.heightAnchor.constraint(equalToConstant: 310),
            coverNFTImageView.topAnchor.constraint(equalTo: view.topAnchor),
            coverNFTImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverNFTImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Collection name:
            nameOfNFTCollectionLabel.topAnchor.constraint(equalTo: coverNFTImageView.bottomAnchor, constant: 16),
            nameOfNFTCollectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            // About author label:
            aboutAuthorLabel.topAnchor.constraint(equalTo: nameOfNFTCollectionLabel.bottomAnchor, constant: 13),
            aboutAuthorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            // Author of collection:
            authorLinkTextView.topAnchor.constraint(equalTo: nameOfNFTCollectionLabel.bottomAnchor, constant: 12),
            authorLinkTextView.leadingAnchor.constraint(equalTo: aboutAuthorLabel.trailingAnchor, constant: 4),
            
            // Information of collection:
            collectionInformationLabel.topAnchor.constraint(equalTo: aboutAuthorLabel.bottomAnchor, constant: 5),
            collectionInformationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionInformationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // CollectionView:
            nftCollection.topAnchor.constraint(equalTo: collectionInformationLabel.bottomAnchor),
            nftCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - Setup Targets:
extension CatalogCollectionViewController {
    private func setupTargets() {
        
    }
}
