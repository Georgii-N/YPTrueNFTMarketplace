//
//  FavouritesNFTViewController.swift
//  FakeNFT
//
//  Created by Тихтей  Павел on 04.08.2023.
//

import UIKit

class FavouritesNFTViewController: UIViewController {
    
    let mockNFTData: [FavouritesNFTCellViewModel] = [
        (FavouritesNFTCellViewModel(NFTImage: UIImage(named: "NFTcard") ?? UIImage(), NFTName: "Lilo", NFTRateImage: UIImage(named: "rate") ?? UIImage(), NFTPrice: "1,78")),
        (FavouritesNFTCellViewModel(NFTImage: UIImage(named: "NFTcard") ?? UIImage(), NFTName: "Lilo", NFTRateImage: UIImage(named: "rate") ?? UIImage(), NFTPrice: "1,78")),
        (FavouritesNFTCellViewModel(NFTImage: UIImage(named: "NFTcard") ?? UIImage(), NFTName: "Lilo", NFTRateImage: UIImage(named: "rate") ?? UIImage(), NFTPrice: "1,78")),
        (FavouritesNFTCellViewModel(NFTImage: UIImage(named: "NFTcard") ?? UIImage(), NFTName: "Lilo", NFTRateImage: UIImage(named: "rate") ?? UIImage(), NFTPrice: "1,78"))
    ]

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
        title = "Избранные NFT"
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
        mockNFTData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FavouritesNFTCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.backgroundColor = .clear
        cell.setupCellData(mockNFTData[indexPath.row])
        return cell
    }
}

extension FavouritesNFTViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.frame.width - 15) / 2, height: 80)
    }
}
