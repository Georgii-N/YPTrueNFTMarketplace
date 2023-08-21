//
//  CustomPageControlView.swift
//  FakeNFT
//
//  Created by Евгений on 16.08.2023.
//

import UIKit

final class CustomPageControlView: UIView {
    
    // MARK: - Constants and Variables:
    enum SizeConstants {
        static let numberOfDots: CGFloat = 3
        static let totalInsets: CGFloat = 64
        static let dotHeight: CGFloat = 4
    }
    
    // MARK: - UI:
    private var firstView = UIView()
    private var secondView = UIView()
    private var thirdView =  UIView()
    
    // MARK: - Lifecycle:
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Methods:
    override func layoutSubviews() {
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Public Methods:
    func setCurrentState(currentPage: Int, isOnboarding: Bool) {
        for (index, view) in [firstView, secondView, thirdView].enumerated() {
            UIView.animate(withDuration: 0.3) {
                if isOnboarding {
                    self.backgroundColor = .clear
                    view.backgroundColor = currentPage == index ? .whiteUniversal : .lightGrayDay
                } else {
                    self.backgroundColor = .whiteDay
                    view.backgroundColor = currentPage == index ? .blackDay : .lightGrayDay
                }
            }
        }
    }
}

// MARK: - Setup Views:
extension CustomPageControlView {
    private func setupViews() {
        [firstView, secondView, thirdView].forEach { [weak self] view in
            guard let self = self else { return }
            view.layer.cornerRadius = 2
            self.setupView(view)
        }
    }
}

// MARK: - Setup Constraints:
extension CustomPageControlView {
    private func setupConstraints() {
        let widht = (bounds.width - SizeConstants.totalInsets) / SizeConstants.numberOfDots
        let height = SizeConstants.dotHeight
        
        NSLayoutConstraint.activate([
            firstView.heightAnchor.constraint(equalToConstant: height),
            firstView.widthAnchor.constraint(equalToConstant: widht),
            firstView.centerYAnchor.constraint(equalTo: centerYAnchor),
            firstView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            firstView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            secondView.heightAnchor.constraint(equalToConstant: height),
            secondView.widthAnchor.constraint(equalToConstant: widht),
            secondView.centerYAnchor.constraint(equalTo: centerYAnchor),
            secondView.leadingAnchor.constraint(equalTo: firstView.trailingAnchor, constant: 8),
            
            thirdView.heightAnchor.constraint(equalToConstant: height),
            thirdView.widthAnchor.constraint(equalToConstant: widht),
            thirdView.centerYAnchor.constraint(equalTo: centerYAnchor),
            thirdView.leadingAnchor.constraint(equalTo: secondView.trailingAnchor, constant: 8)
        ])
    }
}
