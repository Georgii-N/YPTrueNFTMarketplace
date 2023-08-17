import UIKit
import Kingfisher

final class CartViewControler: UIViewController {
    
    // MARK: Public dependencies
    private let cartViewModel: CartViewModelProtocol
    
    // MARK: UI constants and variables
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let sortButton = SortNavBarBaseButton()
    private lazy var refreshControl = UIRefreshControl()
    
    private lazy var totalView: UIView = {
        let totalView = UIView()
        totalView.backgroundColor = .lightGrayDay
        totalView.isHidden = false
        let maskPath = UIBezierPath(roundedRect: view.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 12, height: 12))

        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        totalView.layer.mask = shape
        return totalView
    }()
    
    private lazy var totalNFT: UILabel = {
        let totalNFT = UILabel()
        totalNFT.textColor = .blackDay
        totalNFT.font = UIFont.systemFont(ofSize: 15)
        return totalNFT
    }()
    
    private lazy var totalCost: UILabel = {
        let totalCost = UILabel()
        totalCost.textColor = .greenUniversal
        totalCost.font = UIFont.boldSystemFont(ofSize: 17)
        return totalCost
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = L10n.Cart.MainScreen.emptyCart
        label.isHidden = true
        return label
    }()
    
    private lazy var toPayButton: UIButton = {
        let toPayButton = UIButton()
        toPayButton.backgroundColor = .blackDay
        toPayButton.setTitle(L10n.Cart.MainScreen.toPayButton, for: .normal)
        toPayButton.setTitleColor(.whiteDay, for: .normal)
        toPayButton.layer.cornerRadius = 16
        toPayButton.titleLabel?.textAlignment = .center
        toPayButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        toPayButton.isHidden = false
        return toPayButton
    }()
    
    // MARK: - Lifecycle:
    init(cartViewModel: CartViewModel) {
        self.cartViewModel = cartViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setTargets()
        makeCollectionView()
        bind()
        blockUI()
    }
    
    private func bind() {
        cartViewModel.cartNft.bind {[weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.checkEmptyNFT()
                self.totalNFT.text = "\(self.cartViewModel.additionNFT()) NFT"
                self.totalCost.text = "\(self.cartViewModel.additionPriceNFT()) ETH"
                self.unblockUI()
            }
        }
        
        cartViewModel.networkErrorObservable.bind {[weak self] errorText in
            guard let self = self else { return }
            guard let errorText = errorText else {
                return self.resumeMethodOnMainThread(self.endRefreshing, with: ())
            }
            self.resumeMethodOnMainThread(self.endRefreshing, with: ())
            self.resumeMethodOnMainThread(self.showNotificationBanner, with: errorText)
        }
    }
}

// MARK: Set Up UI
extension CartViewControler {
    private func setupViews() {
        view.backgroundColor = .whiteDay
        [totalView, totalNFT, totalCost, toPayButton, collectionView, emptyLabel].forEach(view.setupView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emptyLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 351),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
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
        sortButton.addTarget(self, action: #selector(makeSort), for: .touchUpInside)
    }
    
    private func checkEmptyNFT() {
        guard let isEmptyCartNft = cartViewModel.cartNft.wrappedValue?.isEmpty else { return }
        if isEmptyCartNft {
            emptyLabel.isHidden = false
            totalView.isHidden = true
            toPayButton.isHidden = true
            totalNFT.isHidden = true
            totalCost.isHidden = true
            self.navigationItem.rightBarButtonItem = nil
            
        } else {
            emptyLabel.isHidden = true
            totalView.isHidden = false
            toPayButton.isHidden = false
            totalNFT.isHidden = false
            totalCost.isHidden = false
            makeSortButton()
        }
    }
    
    @objc
    private func goPayment() {
        let paymentViewModel = PaymentViewModel()
        let paymentViewController = PaymentViewController(paymentViewModel: paymentViewModel)
        paymentViewController.hidesBottomBarWhenPushed = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(paymentViewController, animated: true)
    }
    
    @objc
    private func makeSort() {
        let alert = UniversalAlertService()
        
        alert.showActionSheet(title: L10n.Sorting.title, sortingOptions: [.byPrice, .byRating, .byTitle, .close], on: self) { [weak self] options in
            guard let self = self else { return }
            self.cartViewModel.sortNFT(options)
            
        }
    }
    
    private func makeCollectionView() {
        collectionView.register(CartMainCell.self)
        collectionView.backgroundColor = .whiteDay
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func makeSortButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortButton)
    }
    
    private func resumeMethodOnMainThread<T>(_ method: @escaping ((T) -> Void), with argument: T) {
            DispatchQueue.main.async {
                method(argument)
            }
        }
    
    private func endRefreshing() {
            self.refreshControl.endRefreshing()
            self.unblockUI()
        }
}

// MARK: Collection View
extension CartViewControler: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cartNFT = cartViewModel.unwrappedCartNftViewModel()
        return cartNFT.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CartMainCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let cartNFT = cartViewModel.unwrappedCartNftViewModel()
        let model = cartNFT[indexPath.row]
        cell.setupCollectionModel(model: model)
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
    func didTapDeleteButton(in image: UIImage, idNft: String) {
        let deleteAlert = DeleteItemViewControler(itemImage: image, itemId: idNft)
        deleteAlert.delegate = self
        deleteAlert.modalPresentationStyle = .overFullScreen
        present(deleteAlert, animated: true, completion: nil)
    }
}

extension CartViewControler: DeleteViewControllerDelegate {
    func deleteNft(itemId: String) {
        cartViewModel.sendDeleteNft(id: itemId) {[weak self] result in
            guard let self = self else { return }
            if result {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.checkEmptyNFT()
                    self.totalNFT.text = "\(self.cartViewModel.additionNFT()) NFT"
                    self.totalCost.text = "\(self.cartViewModel.additionPriceNFT()) ETH"
                }
            }
        }
    }
}
