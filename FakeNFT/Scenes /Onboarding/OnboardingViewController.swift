import UIKit

final class OnboardingViewController: UIViewController {
    
    // MARK: - Private Dependencies:
    private var viewModel: OnboardingViewModelProtocol
    private weak var delegate: OnboardingViewControllerDelegate?
    
    // MARK: - UI:
    private lazy var onboardingScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        scrollView.contentSize = CGSize(width: view.frame.width * 3, height: view.frame.height)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        return scrollView
    }()
        
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Resources.Images.Onboarding.cancelButton, for: .normal)
        
        return button
    }()
    
    private lazy var enterButton = BaseBlackButton(with: L10n.Onboarding.isWhatInside)
    
    private lazy var screenTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .headlineOnboarding
        label.textColor = .whiteUniversal
        
        return label
    }()
    
    private lazy var screenDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .bodySmallRegular
        label.textColor = .whiteUniversal
        
        return label
    }()
    
    private lazy var pageControlView = CustomPageControlView()
    
    // MARK: - Lifecycle:
    init(viewModel: OnboardingViewModelProtocol, delegate: OnboardingViewControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupScrollView()
        setupTargets()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AnalyticsService.instance.sentEvent(screen: .onboardingMain, item: .screen, event: .open)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AnalyticsService.instance.sentEvent(screen: .onboardingMain, item: .screen, event: .close)
    }

    // MARK: - Private Methods:
    private func setupScrollView() {
        let widht = view.frame.width
        let height = view.frame.height
        let firstImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: widht, height: height))
        let secondImageView = UIImageView(frame: CGRect(x: widht, y: 0, width: widht, height: height))
        let thirdImageView = UIImageView(frame: CGRect(x: widht * CGFloat(2), y: 0, width: widht, height: height))
        
        setImageView(imageViews: [firstImageView, secondImageView, thirdImageView])
    }
    
    private func setImageView(imageViews: [UIImageView]) {
        for (index, imageView) in imageViews.enumerated() {
            let view = self.makeGradient(view: imageView)
            setImage(page: index, imageView: imageView)
            setTitlesAndDescriptions(page: index, view: view)
            
            onboardingScrollView.addSubview(view)
            
            if index == 2 {
                setEnterButton(view: view)
            }
        }
    }
    
    private func setImage(page: Int, imageView: UIImageView) {
        let image = viewModel.getImage(index: page)
        imageView.image = image
    }
    
    private func setTitlesAndDescriptions(page: Int, view: UIView) {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = viewModel.getTitle(index: page)
        titleLabel.font = .headlineOnboarding
        titleLabel.textColor = .whiteUniversal
        
        view.setupView(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 230),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        setDescriptions(page: page, view: view, titleLabel: titleLabel)
    }
    
    private func setDescriptions(page: Int, view: UIView, titleLabel: UILabel) {
        let descriptionLabel = UILabel()
        let text = viewModel.getDescription(index: page)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = text
        descriptionLabel.font = .bodySmallRegular
        descriptionLabel.textColor = .whiteUniversal
        
        view.setupView(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setEnterButton(view: UIView) {
        self.view.setupView(enterButton)
        
        NSLayoutConstraint.activate([
            enterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            enterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            enterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -66)
        ])
    }
    
    private func makeGradient(view: UIView) -> UIView {
        let gradient = CAGradientLayer()
        let firstColor = UIColor.onboardingTopGradientColor
        let secondColor = UIColor.onboardingBottomGradientColor
        
        gradient.colors = [firstColor, secondColor]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = view.bounds
        
        view.layer.insertSublayer(gradient, at: 0)
        
        return view
    }
    
    // MARK: - Objc Methods:
    @objc private func switchToTabBarController() {
        let viewController = TabBarController()
        viewController.modalPresentationStyle = .overFullScreen
        
        present(viewController, animated: true)
    }
    
    @objc private func backToAuthVC() {
        dismiss(animated: true)
        delegate?.backToAuth()
    }
}

// MARK: - UIScrollViewDelegate
extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x / view.frame.width)
        
        pageControlView.setCurrentState(currentPage: Int(page), isOnboarding: true)
    }
}

// MARK: - Setup Views:
extension OnboardingViewController {
    private func setupViews() {
        view.backgroundColor = .blackDay
        [onboardingScrollView, pageControlView, cancelButton, screenTitleLabel,
         screenDescriptionLabel].forEach(view.setupView)
        
        pageControlView.setCurrentState(currentPage: 0, isOnboarding: true)
    }
}

// MARK: - Setup Constraints:
extension OnboardingViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            onboardingScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            onboardingScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            onboardingScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            onboardingScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            pageControlView.heightAnchor.constraint(equalToConstant: 28),
            pageControlView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageControlView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageControlView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 42),
            cancelButton.widthAnchor.constraint(equalToConstant: 42),
            cancelButton.topAnchor.constraint(equalTo: pageControlView.bottomAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

// MARK: - Setup Targets:
extension OnboardingViewController {
    private func setupTargets() {
        cancelButton.addTarget(self, action: #selector(backToAuthVC), for: .touchUpInside)
        enterButton.addTarget(self, action: #selector(switchToTabBarController), for: .touchUpInside)
    }
}
