//
//  Onboarding.swift
//  FakeNFT
//
//  Created by Евгений on 10.08.2023.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    // MARK: - UI:
    private lazy var onboardingScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        scrollView.contentSize = CGSize(width: view.frame.width * 3, height: view.frame.height)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        return scrollView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.currentPageIndicatorTintColor = .whiteUniversal
        pageControl.pageIndicatorTintColor = .lightGrayDay
        
        return pageControl
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Resources.Images.Onboarding.cancelButton, for: .normal)
        
        return button
    }()
    
    private lazy var enterButton = BaseBlackButton(with: L10n.Onboarding.isWhatInside)
    
    private lazy var screenTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 32)
        label.textColor = .whiteUniversal
        
        return label
    }()
    
    private lazy var screenDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .whiteUniversal
        
        return label
    }()
    
    // MARK: - Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupScrollView()
    }
    
    // MARK: - Private Methods:
    private func setupScrollView() {
        let widht = view.frame.width
        let height = view.frame.height
        let firstImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: widht, height: height))
        let secondImageView = UIImageView(frame: CGRect(x: widht, y: 0, width: widht, height: height))
        let thirdImageView = UIImageView(frame: CGRect(x: widht * CGFloat(2), y: 0, width: widht, height: height))
        
        firstImageView.image = Resources.Images.Onboarding.firstImage
        secondImageView.image = Resources.Images.Onboarding.secondImage
        thirdImageView.image = Resources.Images.Onboarding.thirdImage
                
        thirdImageView.addSubview(enterButton)
        
        NSLayoutConstraint.activate([
            enterButton.leadingAnchor.constraint(equalTo: thirdImageView.leadingAnchor, constant: 16),
            enterButton.trailingAnchor.constraint(equalTo: thirdImageView.trailingAnchor, constant: -16),
            enterButton.bottomAnchor.constraint(equalTo: thirdImageView.bottomAnchor, constant: -66)
        ])
        
        [firstImageView, secondImageView, thirdImageView].forEach({ [weak self] imageView in
            guard let self = self else { return }
            let view = self.makeGradient(view: imageView)
            onboardingScrollView.addSubview(view)
        })
    }
    
    private func setTitleAndDescription(page: Int) {
        
    }
    
    private func makeGradient(view: UIView) -> UIView {
        let gradient = CAGradientLayer()
        let firstColor = UIColor(red: 26.0/255.0, green: 27.0/255.0, blue: 34.0/255.0, alpha: 1.0).cgColor
        let secondColor = UIColor(red: 26.0/255.0, green: 27.0/255.0, blue: 34.0/255.0, alpha: 0.0).cgColor

        gradient.colors = [firstColor, secondColor]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = view.bounds
        
        view.layer.insertSublayer(gradient, at: 0)
        
        return view
    }
}

// MARK: - UIScrollViewDelegate
extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x / view.frame.width)
        
        pageControl.currentPage = Int(page)
    }
}

// MARK: - Setup Views:
extension OnboardingViewController {
    private func setupViews() {
        view.backgroundColor = .blackDay
        [onboardingScrollView, pageControl, cancelButton, enterButton, screenTitleLabel,
         screenDescriptionLabel].forEach(view.setupView)
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
            
            pageControl.heightAnchor.constraint(equalToConstant: 28),
            pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 42),
            cancelButton.widthAnchor.constraint(equalToConstant: 42),
            cancelButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
