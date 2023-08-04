//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Тихтей  Павел on 01.08.2023.
//

import UIKit

class MyNFTViewController: UIViewController {
    
    let mockNFTData: [MyNFTCellViewModel] = [
        (MyNFTCellViewModel(NFTImage: UIImage(named: "NFTcard") ?? UIImage(), NFTName: "Lilo", NFTRateImage: UIImage(named: "rate") ?? UIImage(), NFTFromName: "от John Doe", NFTPrice: "1,78")),
        (MyNFTCellViewModel(NFTImage: UIImage(named: "NFTcard") ?? UIImage(), NFTName: "Lilo", NFTRateImage: UIImage(named: "rate") ?? UIImage(), NFTFromName: "от John Doe", NFTPrice: "1,78")),
        (MyNFTCellViewModel(NFTImage: UIImage(named: "NFTcard") ?? UIImage(), NFTName: "Lilo", NFTRateImage: UIImage(named: "rate") ?? UIImage(), NFTFromName: "от John Doe", NFTPrice: "1,78")),
        (MyNFTCellViewModel(NFTImage: UIImage(named: "NFTcard") ?? UIImage(), NFTName: "Lilo", NFTRateImage: UIImage(named: "rate") ?? UIImage(), NFTFromName: "от John Doe", NFTPrice: "1,78")),
        (MyNFTCellViewModel(NFTImage: UIImage(named: "NFTcard") ?? UIImage(), NFTName: "Lilo", NFTRateImage: UIImage(named: "rate") ?? UIImage(), NFTFromName: "от John Doe", NFTPrice: "1,78"))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViews()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .whiteDay
        view.tintColor = .blackDay
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "goBack"), style: .plain, target: self, action: #selector(goBackButtonTapped))
        title = "Мои NFT"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "sort"), style: .plain, target: self, action: #selector(sortButtonTapped))
    }
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
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
    
    // MARK: - Actions
    
    @objc private func goBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func sortButtonTapped() {
        self.dismiss(animated: true)
    }
}

extension MyNFTViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mockNFTData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MyNFTCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.setupCellData(mockNFTData[indexPath.row])
        return cell
    }
}

extension MyNFTViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 108)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
}
