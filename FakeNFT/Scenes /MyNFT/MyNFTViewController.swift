//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Тихтей  Павел on 01.08.2023.
//

import UIKit

class MyNFTViewController: UIViewController {

    // MARK: - Properties

    var likeNFTIds = [String]()
    var nftIds = [String]()

    private var viewModel: MyNFTViewModelProtocol?
    private var alertService: AlertServiceProtocol?
    private lazy var dataProvider = DataProvider()
    
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
            self?.nftIds = profile?.nfts ?? []
            self?.likeNFTIds = profile?.likes ?? []
            self?.viewModel?.fetchNtfCards(nftIds: self?.nftIds ?? [])
        })
        viewModel?.showErrorAlert = { [weak self] message in
            DispatchQueue.main.async {
                self?.showErrorAlert(message: message)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK: - Init

    init(viewModel: MyNFTViewModel?) {
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
        alertService = nil
        viewModel?.sortNFTCollection(option: sortOptions)
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
    
    @objc private func sortButtonTapped() {
        alertService = UniversalAlertService()
        alertService?.showActionSheet(title: L10n.Sorting.title,
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
        return viewModel?.nftCardsObservable.wrappedValue?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MyNFTCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
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

extension MyNFTViewController: MyNFTCollectionViewCellDelegate {
    func didTapLikeButton(id: String) {
        if likeNFTIds.contains(id) {
            likeNFTIds.removeAll { $0 == id }
        } else {
            likeNFTIds.append(id)
        }

        collectionView.reloadData()
        viewModel?.changeProfile(likesIds: likeNFTIds)
    }
}
