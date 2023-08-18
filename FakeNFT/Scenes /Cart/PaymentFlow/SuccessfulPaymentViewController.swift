import UIKit

final class SuccessfulPaymentViewController: UIViewController {
    
    //MARK: Dependencies
    var isSuccess: Bool
    
    // MARK: UI constants and variables
    private let returnInCatalogButton = BaseBlackButton(with: L10n.Cart.SuccessfulPayment.toBackCatalogButton)
    
    private lazy var successefulImage: UIImageView = {
        let successefulImage = UIImageView()
        return successefulImage
    }()
    
    private lazy var successefulLabel: UILabel = {
        let successefulLabel = UILabel()
        successefulLabel.numberOfLines = 2
        successefulLabel.textAlignment = .center
        successefulLabel.textColor = .blackDay
        successefulLabel.font = UIFont.boldSystemFont(ofSize: 22)
        return successefulLabel
    }()
    
    // MARK: - Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setSuccessViews()
        setupConstraints()
        setTargets()
    }
    
    init(isSuccess: Bool) {
        self.isSuccess = isSuccess
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Set Up UI
extension SuccessfulPaymentViewController {
    
    private func setupViews() {
        view.backgroundColor = .whiteDay
        [successefulImage, successefulLabel, returnInCatalogButton].forEach(view.setupView)
    }
    
    private func setSuccessViews() {
        if isSuccess {
            successefulImage.image = UIImage(named: "success")
            successefulLabel.text = L10n.Cart.SuccessfulPayment.successful
            AnalyticsService.instance.sentEvent(screen: .cartMain, item: .screen, event: .success)
        } else {
            successefulImage.image = UIImage(named: "unsuccess")
            successefulLabel.text = L10n.Cart.UnsuccessfulPayment.unsuccessful
            returnInCatalogButton.setTitle(L10n.Cart.UnsuccessfulPayment.tryAgain, for: .normal)
            AnalyticsService.instance.sentEvent(screen: .cartMain, item: .screen, event: .unsuccess)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            successefulImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 152),
            successefulImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successefulLabel.topAnchor.constraint(equalTo: successefulImage.bottomAnchor, constant: 20),
            successefulLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 36),
            successefulLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -36),
            returnInCatalogButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            returnInCatalogButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            returnInCatalogButton.widthAnchor.constraint(equalToConstant: 343)
        ])
    }
    
    private func setTargets() {
        if isSuccess {
            returnInCatalogButton.addTarget(self, action: #selector(backToCatalog), for: .touchUpInside)
        } else {
            returnInCatalogButton.addTarget(self, action: #selector(tryLoadOrderPay), for: .touchUpInside)
        }
        
    }
    
    @objc
   private func backToCatalog() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func tryLoadOrderPay() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.popViewController(animated: true)
    }
}
