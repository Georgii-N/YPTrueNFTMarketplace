//
//  FavouritesNFTViewController.swift
//  FakeNFT
//
//  Created by Тихтей  Павел on 04.08.2023.
//

import UIKit

class FavouritesNFTViewController: UIViewController {

    // MARK: - Properties

    private var likesIds = [String]()

    private var viewModel: FavouritesNFTViewModelProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViews() 
        setupConstraints()
        
        viewModel?.nftCardsObservable.bind(action: { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        })
        viewModel?.profileObservable.bind(action: { [weak self] profile in
            self?.likesIds = profile?.likes ?? []
            self?.viewModel?.fetchNtfCards(likes: self?.likesIds ?? [])
        })
        viewModel?.showErrorAlert = { [weak self] message in
            DispatchQueue.main.async {
                self?.showErrorAlert(message: message)
            }
        }
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
    
    // MARK: - Alert
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions
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
        cell.delegate = self
        cell.setupCellData(.init(name: nft.name,
                                 images: nft.images,
                                 rating: nft.rating,
                                 price: nft.price,
                                 author: users.first(where: { $0.id == nft.author })?.name ?? "",
                                 id: nft.id,
                                 isLiked: likesIds.contains(nft.id),
                                 isAddedToCard: false))
        return cell
    }
}

extension FavouritesNFTViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.frame.width - 15) / 2, height: 80)
    }
}

extension FavouritesNFTViewController: FavouritesNFTCollectionViewCellDelegate {
    func didTapLikeButton(id: String) {
        if likesIds.contains(id) {
            likesIds.removeAll { $0 == id }
        } else {
            likesIds.append(id)
        }

        collectionView.reloadData()
        viewModel?.changeProfile(likesIds: likesIds)
    }
}
