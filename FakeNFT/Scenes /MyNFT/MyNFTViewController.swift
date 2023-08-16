//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Тихтей  Павел on 01.08.2023.
//

import UIKit

class MyNFTViewController: UIViewController {

    // MARK: - Properties

    var nftCards = [NFTCard]()
    var likeNFTIds = [String]()

    private var alertService: AlertServiceProtocol?
    private lazy var dataProvider = DataProvider()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - SetupUI
    
    private func setupUI() {
        view.backgroundColor = .whiteDay
        view.tintColor = .blackDay
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "goBack"), style: .plain, target: self, action: #selector(goBackButtonTapped))
        title = L10n.Profile.MainScreen.myNFT
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Resources.Images.NavBar.sortIcon, style: .plain, target: self, action: #selector(sortButtonTapped))
    }
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MyNFTCollectionViewCell.self)
        return collectionView
    }()
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 36),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupViews() {
        view.setupView(collectionView)
    }
    
    private func sortNFT(_ sortOptions: SortingOption) {
        switch sortOptions {
        case .byPrice:
            print("price")
        case .byRating:
            print("rating")
        case .byName:
            print("name")
        default:
            break
        }
        alertService = nil
    }
    
    // MARK: - Actions
    
    @objc private func goBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func sortButtonTapped() {
        alertService = UniversalAlertService()
        alertService?.showActionSheet(title: L10n.Alert.sortTitle,
                                      sortingOptions: [.byPrice, .byRating, .byName, .close],
                                      on: self,
                                      completion: { [weak self] options in
            guard let self = self else { return }
            self.sortNFT(options)
        })
    }
}

// MARK: - UICollectionViewDelegate&UICollectionViewDataSource
extension MyNFTViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nftCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MyNFTCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.backgroundColor = .clear
        let nft = nftCards[indexPath.row]
        cell.setupCellData(.init(name: nft.name,
                                 images: nft.images,
                                 rating: nft.rating,
                                 price: nft.price,
                                 author: nft.author,
                                 id: nft.id,
                                 isLiked: likeNFTIds.contains(nft.id),
                                 isAddedToCard: false))
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MyNFTViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 108)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
}
