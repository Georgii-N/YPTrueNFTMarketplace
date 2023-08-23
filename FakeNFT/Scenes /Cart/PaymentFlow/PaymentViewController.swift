import UIKit

final class PaymentViewController: UIViewController {
    
    // MARK: Dependencies
    private let paymentViewModel: PaymentViewModelProtocol
    
    // MARK: UI constants and variables
    private let payButton = BaseButton(with: .black, title: L10n.Cart.PayScreen.payButton)
    private let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse/")
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var refreshControl = UIRefreshControl()
    
    private lazy var bottomView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = .lightGrayDay
        let maskPath = UIBezierPath(roundedRect: view.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 12, height: 12))

        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        bottomView.layer.mask = shape
        return bottomView
    }()
    
    private lazy var userTerms: UILabel = {
        let userTerms = UILabel()
        userTerms.textColor = .blackDay
        userTerms.font = UIFont.systemFont(ofSize: 13)
        userTerms.text = L10n.Cart.PayScreen.userTerms
        return userTerms
    }()
    
    private lazy var userTermsLink: UIButton = {
        let userTermsLink = UIButton()
        userTermsLink.setTitle(L10n.Cart.PayScreen.userTermsLink, for: .normal)
        userTermsLink.setTitleColor(.blueUniversal, for: .normal)
        userTermsLink.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return userTermsLink
    }()
    
    // MARK: - Lifecycle:
    init(paymentViewModel: PaymentViewModel) {
        self.paymentViewModel = paymentViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        makeCollectionView()
        setTargets()
        blockUI(withBlur: true)
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  blockUI(withBlur: true)
      //  paymentViewModel.getData()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func bind() {
        paymentViewModel.currencieNfts.bind {[weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.unblockUI()
            }
        }
        
        paymentViewModel.networkErrorObservable.bind {[weak self] errorText in
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
extension PaymentViewController {
    
    private func setupViews() {
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
        userTermsLink.addTarget(self, action: #selector(openUserTerms), for: .touchUpInside)
    }
    
    private func makeCollectionView() {
        collectionView.register(CartPaymentCell.self)
        collectionView.backgroundColor = .whiteDay
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: Private Methods
    @objc
    private func goToSuccessScreen() {
        paymentViewModel.makePay { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case true:
                    
                    let successViewController = SuccessfulPaymentViewController(isSuccess: true)
                    self.navigationController?.pushViewController(successViewController, animated: true)
                case false:
                    let unsuccessViewController = SuccessfulPaymentViewController(isSuccess: false)
                    self.navigationController?.pushViewController(unsuccessViewController, animated: true)
                }
            }
        }
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc
    private func openUserTerms() {
        let webViewModel = WebViewViewModel()
        let webViewController = WebViewViewController(viewModel: webViewModel, url: url)
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    private func endRefreshing() {
        self.refreshControl.endRefreshing()
        self.unblockUI()
    }
}

// MARK: Collection View
extension PaymentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let currencieNFT = paymentViewModel.unwrappedPaymentViewModel()
        return currencieNFT.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currencieNFT = paymentViewModel.unwrappedPaymentViewModel()
        let modelCurrencie = currencieNFT[indexPath.row]
        let cell: CartPaymentCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.setupCollectionModel(model: modelCurrencie)
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
        let currencieNFT = paymentViewModel.unwrappedPaymentViewModel()
        cell.layer.borderColor = UIColor.blackDay.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 12
        let id = Int(currencieNFT[indexPath.row].id)
        paymentViewModel.currencieID = id
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CartPaymentCell else { return }
        cell.layer.borderWidth = 0
    }
}
