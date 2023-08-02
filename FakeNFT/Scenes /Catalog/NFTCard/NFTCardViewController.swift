//
//  NFTCard.swift
//  FakeNFT
//
//  Created by Евгений on 02.08.2023.
//

import UIKit

final class NFTCardViewController: UIViewController {
    
    // MARK: - Private Dependencies:
    private var viewModel: NFTCardViewModelProtocol?
    
    // MARK: Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupTargets()
    }
    
    init(viewModel: NFTCardViewModelProtocol?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup Views:
extension NFTCardViewController {
    private func setupViews() {
        view.backgroundColor = .whiteDay
    }
}

// MARK: - Setup Constraints:
extension NFTCardViewController {
    private func setupConstraints() {
        
    }
}

// MARK: - Setup Targets:
extension NFTCardViewController {
    private func setupTargets() {
        
    }
}
