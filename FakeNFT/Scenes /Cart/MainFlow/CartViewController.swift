//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Даниил Крашенинников on 30.07.2023.
//

import UIKit
import Kingfisher

final class CartViewControler: UIViewController {
    
    var cartViewModel: CartViewModel
    
// MARK: UI constants and variables
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private lazy var totalView: UIView = {
        let totalView = UIView()
        totalView.backgroundColor = .lightGray
        return totalView
    }()
    
    private lazy var totalNFT: UILabel = {
        let totalNFT = UILabel()
        totalNFT.textColor = .blackDay
        totalNFT.font = UIFont.systemFont(ofSize: 15)
       // totalNFT.text = "3 NFT"
       // totalNFT.text = "\(cartViewModel.additionNFT()) NFT"
        return totalNFT
    }()
    
    private lazy var totalCost: UILabel = {
        let totalCost = UILabel()
        totalCost.textColor = .greenUniversal
      //  totalCost.text = "5,34 ETH"
      //  totalCost.text = "\(cartViewModel.additionPriceNFT()) ETH"
        totalCost.font = UIFont.boldSystemFont(ofSize: 17)
        return totalCost
    }()
    
    private lazy var toPayButton: UIButton = {
        let toPayButton = UIButton()
        toPayButton.backgroundColor = .blackDay
        toPayButton.setTitle(L10n.Cart.MainScreen.toPayButton, for: .normal)
        toPayButton.setTitleColor(.whiteDay, for: .normal)
        toPayButton.layer.cornerRadius = 16
        toPayButton.titleLabel?.textAlignment = .center
        toPayButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return toPayButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setupConstraints()
        setTargets()
        makeCollectionView()
        makeSortButton()
        bind()
           }
    
    private func bind() {
        cartViewModel.$cartNFT.bind {[weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.totalNFT.text = "\(self.cartViewModel.additionNFT()) NFT"
                self.totalCost.text = "\(self.cartViewModel.additionPriceNFT()) ETH"
            }
        }
    }
    init(cartViewModel: CartViewModel) {
        self.cartViewModel = cartViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Set Up UI
extension CartViewControler {
   private func setUpViews() {
        view.backgroundColor = .whiteDay
        [totalView, totalNFT, totalCost, toPayButton, collectionView].forEach(view.setupView)
    }
    
   private func setupConstraints() {
        NSLayoutConstraint.activate([
            totalView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            totalView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            totalView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            totalView.heightAnchor.constraint(equalToConstant: 76),
            totalNFT.topAnchor.constraint(equalTo: totalView.topAnchor, constant: 16),
            totalNFT.leadingAnchor.constraint(equalTo: totalView.leadingAnchor, constant: 16),
            totalCost.topAnchor.constraint(equalTo: totalNFT.bottomAnchor, constant: 2),
            totalCost.leadingAnchor.constraint(equalTo: totalView.leadingAnchor, constant: 16),
            toPayButton.topAnchor.constraint(equalTo: totalView.topAnchor, constant: 16),
            toPayButton.trailingAnchor.constraint(equalTo: totalView.trailingAnchor, constant: -16),
            toPayButton.widthAnchor.constraint(equalToConstant: 240),
            toPayButton.heightAnchor.constraint(equalToConstant: 44),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.bottomAnchor.constraint(equalTo: totalView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
   private func setTargets() {
        toPayButton.addTarget(self, action: #selector(goPayment), for: .touchUpInside)
    }
    
    @objc
   private func goPayment() {
        let paymentViewController = PaymentViewController()
        paymentViewController.hidesBottomBarWhenPushed = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(paymentViewController, animated: true)
    }
    
   private func makeCollectionView() {
        collectionView.register(CartMainCell.self)
        collectionView.backgroundColor = .whiteDay
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
   private func makeSortButton() {
        let sortButton = SortNavBarBaseButton()
       navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortButton)
    }
}

// MARK: Collection View
extension CartViewControler: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cartViewModel.cartNFT.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CartMainCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let imageUrl = URL(string: cartViewModel.cartNFT[indexPath.row].images[0])
        let size = CGSize(width: 115, height: 115)
        let resizingProcessor = ResizingImageProcessor(referenceSize: size)
        cell.nameNFT.text = cartViewModel.cartNFT[indexPath.row].name
        cell.priceCountNFT.text = "\(String(cartViewModel.cartNFT[indexPath.row].price)) ETH"
        cell.imageNFT.kf.setImage(with: imageUrl, options: [.processor(resizingProcessor)])
        cell.setRating(rating: cartViewModel.cartNFT[indexPath.row].rating)
        cell.delegate = self
        return cell
    }
}

extension CartViewControler: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 375, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension CartViewControler: CartMainCellDelegate {
    func didTapDeleteButton(in cell: CartMainCell) {
        guard let imageCell = cell.imageNFT.image else { return }
        let deleteAlert = DeleteItemViewControler(itemImage: imageCell)
            deleteAlert.modalPresentationStyle = .overFullScreen
        present(deleteAlert, animated: true, completion: nil)
    }
}
