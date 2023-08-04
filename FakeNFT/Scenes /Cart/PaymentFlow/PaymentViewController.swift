//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Даниил Крашенинников on 31.07.2023.
//

import UIKit

final class PaymentViewController: UIViewController {
    
// MARK: UI constants and variables
    private let payButton = BaseBlackButton(with: L10n.Cart.PayScreen.payButton)
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private lazy var bottomView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = .lightGray
        return bottomView
    }()
    
    private lazy var userTerms: UILabel = {
        let userTerms = UILabel()
        userTerms.textColor = .blackDay
        userTerms.font = UIFont.systemFont(ofSize: 13)
        userTerms.text = L10n.Cart.PayScreen.userTerms
        return userTerms
    }()
    
    private lazy var userTermsLink: UILabel = {
        let userTermsLink = UILabel()
        userTermsLink.textColor = .blackDay
        userTermsLink.font = UIFont.systemFont(ofSize: 13)
        userTermsLink.text = L10n.Cart.PayScreen.userTermsLink
        return userTermsLink
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setupConstraints()
        makeCollectionView()
        setTargets()
    }
}

// MARK: Set Up UI
extension PaymentViewController {
    
   private func setUpViews() {
        view.backgroundColor = .whiteDay
        self.title = L10n.Cart.PayScreen.paymentChoice
        [bottomView, userTerms, userTermsLink, payButton, collectionView].forEach(view.setupView)
    }
    
   private func setupConstraints() {
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 186),
            userTerms.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            userTerms.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            userTermsLink.topAnchor.constraint(equalTo: userTerms.bottomAnchor),
            userTermsLink.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            payButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 76),
            payButton.widthAnchor.constraint(equalToConstant: 343),
            payButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
        ])
    }
    
   private func setTargets() {
        payButton.addTarget(self, action: #selector(goToSuccessScreen), for: .touchUpInside)
    }
    
   private func makeCollectionView() {
        collectionView.register(CartPaymentCell.self)
        collectionView.backgroundColor = .whiteDay
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @objc
   private func goToSuccessScreen() {
        let successViewController = UnsuccessfulPaymentViewController()
            navigationController?.setNavigationBarHidden(true, animated: true)
            navigationController?.pushViewController(successViewController, animated: true)
    }
}

// MARK: Collection View
extension PaymentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CartPaymentCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        return cell
    }
    
}
extension PaymentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/2 - 7), height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CartPaymentCell else { return }
        cell.layer.borderColor = UIColor.blackDay.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 12
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CartPaymentCell else { return }
        cell.layer.borderWidth = 0
        }
}
