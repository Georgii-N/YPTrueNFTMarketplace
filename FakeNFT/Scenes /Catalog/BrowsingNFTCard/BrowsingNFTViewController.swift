//
//  BrowsingNFTViewController.swift
//  FakeNFT
//
//  Created by Евгений on 08.08.2023.
//

import UIKit
import Kingfisher

final class BrowsingNFTViewController: UIViewController {
    
    // MARK: - Private Classes:
    private let analyticsService = AnalyticsService.instance
    
    // MARK: - Constants and Variables:
    private var urlStringsImageView = [String]()
    
    // MARK: - UI:
    private lazy var imageScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        scrollView.contentSize = CGSize(width: view.frame.width * 3, height: view.frame.height)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        
        return scrollView
    }()
        
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Resources.Images.NFTBrowsing.cancellButton, for: .normal)
        
        return button
    }()
    
    private lazy var pageControllView = CustomPageControlView()
    
    // MARK: - Lifecycle
    init(urlStrings: [String]) {
        self.urlStringsImageView = urlStrings
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupTargets()
        
        loadImages()
        
        imageScrollView.maximumZoomScale = 1.25
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsService.sentEvent(screen: .browsingNFTCard, item: .screen, event: .open)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.sentEvent(screen: .browsingNFTCard, item: .screen, event: .close)
    }
    
    // MARK: - Private Methods:
    private func rescaleAndCenterImageInScrollView(image: UIImage?) {
        guard let image = image else { return }
        let minZoomScale = imageScrollView.minimumZoomScale
        let maxZoomScale = imageScrollView.maximumZoomScale
        view.layoutIfNeeded()
        
        let visibleRectSize = imageScrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.height / imageSize.height
        let wScale = visibleRectSize.width / imageSize.width
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, wScale)))
        imageScrollView.setZoomScale(scale, animated: false)
        imageScrollView.layoutIfNeeded()
        let newContentSize = imageScrollView.contentSize
        let xAxis = (newContentSize.width - visibleRectSize.width) / 2
        let yAxis = (newContentSize.height - visibleRectSize.height) / 2
        imageScrollView.setContentOffset(CGPoint(x: xAxis, y: yAxis), animated: false)
    }
    
    private func loadImages() {
        let imageWidht = view.frame.width
        
        for (index, urlString) in urlStringsImageView.enumerated() {
            guard let url = URL(string: urlString) else { return }
            let imageView = UIImageView(frame: CGRect(x: imageWidht * CGFloat(index), y: 193, width: imageWidht, height: 375))
            imageScrollView.addSubview(imageView)
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: url, options: [.transition(.fade(1))])
        }
    }
    
    // MARK: - Objc Methods:
    @objc private func cancelFromView() {
        dismiss(animated: true)
    }
}

// MARK: - UIScrollViewDelegate
extension BrowsingNFTViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x / view.frame.width)
        pageControllView.setCurrentState(currentPage: Int(page), isOnboarding: false)

        analyticsService.sentEvent(screen: .browsingNFTCard, item: .swipeNFTCard, event: .click)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        let page = round(scrollView.contentOffset.x / view.frame.width)
        
        analyticsService.sentEvent(screen: .browsingNFTCard, item: .scaleNFTCard, event: .click)
        
        return imageScrollView.subviews[Int(page)]
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {

    }
}

// MARK: - Setup Views:
extension BrowsingNFTViewController {
    private func setupViews() {
        view.backgroundColor = .whiteDay
        view.setupView(imageScrollView)
        view.setupView(pageControllView)
        view.setupView(cancelButton)
        
        pageControllView.setCurrentState(currentPage: 0, isOnboarding: false)
    }
}

// MARK: - Setup Constraints:
extension BrowsingNFTViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            pageControllView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -28),
            pageControllView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageControllView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            cancelButton.widthAnchor.constraint(equalToConstant: 42),
            cancelButton.heightAnchor.constraint(equalToConstant: 42),
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

// MARK: - Setup Targets:
extension BrowsingNFTViewController {
    private func setupTargets() {
        cancelButton.addTarget(self, action: #selector(cancelFromView), for: .touchUpInside)
    }
}
