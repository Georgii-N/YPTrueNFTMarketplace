//
//  FavouritesNFTViewController.swift
//  FakeNFT
//
//  Created by Тихтей  Павел on 04.08.2023.
//

import UIKit

class FavouritesNFTViewController: UIViewController {

    // MARK: - Properties

    var likesIds: [String]?

    private var viewModel: FavouritesNFTViewModelProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViews() 
        setupConstraints()
        viewModel?.fetchNtfCards(likes: likesIds ?? [])
        viewModel?.usersObservable.bind(action: { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        })
        viewModel?.nftCardsObservable.bind(action: { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        })
    }

    // MARK: - Init

    init(viewModel: FavouritesNFTViewModelProtocol?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetupUI

    private func setupUI() {
        view.backgroundColor = .whiteDay
        view.tintColor = .blackDay
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "goBack"), style: .plain, target: self, action: #selector(goBackButtonTapped))
        title = L10n.Profile.MainScreen.favouritesNFT
    }
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FavouritesNFTCollectionViewCell.self)
        return collectionView
    }()
    
    private func setupViews() {
        view.setupView(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 36),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func goBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension FavouritesNFTViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return viewModel?.nftCardsObservable.wrappedValue?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FavouritesNFTCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.backgroundColor = .clear
        guard let nft = viewModel?.nftCardsObservable.wrappedValue?[indexPath.row],
              let users = viewModel?.usersObservable.wrappedValue else { return cell }

        cell.setupCellData(.init(name: nft.name,
                                 images: nft.images,
                                 rating: nft.rating,
                                 price: nft.price,
                                 author: users.first(where: { $0.id == nft.author })?.name ?? "",
                                 id: nft.id,
                                 isLiked: true,
                                 isAddedToCard: false))
        return cell
    }
}

extension FavouritesNFTViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.frame.width - 15) / 2, height: 80)
    }
}
