//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Евгений on 31.07.2023.
//

import UIKit

final class CatalogViewController: UIViewController {
    // MARK: - UI:
    private lazy var catalogNFTTableView: UITableView = {
        var tableView = UITableView()
        tableView.register(CatalogTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .whiteDay
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    private lazy var sortButton = SortNavBarBaseButton()
    
    // MARK: - Public Dependencies:
    var viewModel: CatalogViewModelProtocol?
    var alertService: AlertServiceProtocol?
    
    // MARK: - Override Methods:
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupTargets()        
    }
    
    // MARK: - Private Methods:
    private func sortNFT(_ sortOptions: SortingOption) {
        switch sortOptions {
        case .byName:
            print("SORT BY NAME")
        case .byQuantity:
            print("SORT BY QUANTITY")
        default:
            break
        }
    }
    
    // MARK: - Objc Methods:
    @objc private func sortButtonTarget() {
        alertService = UniversalAlertService()
        
        alertService?.showActionSheet(title: L10n.Alert.sortTitle,
                                                sortingOptions: [.byName, .byQuantity, .close],
                                                on: self,
                                                completion: { [weak self] options in
            guard let self = self else { return }
            self.sortNFT(options)
        })
        
        alertService = nil
    }
}

// MARK: - UITableViewDataSource
extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.mockImages.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "CatalogTableViewCell") as? CatalogTableViewCell,
              let viewModel = viewModel,
              let image = viewModel.mockImages[indexPath.row] else { return UITableViewCell() }
        
        let cellLabel = viewModel.mockLabels[indexPath.row]
        
        cell.setupContentImage(image)
        cell.setupLabelText(text: cellLabel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        180
    }
}

// MARK: - UITableViewDelegate
extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - Setup Views:
extension CatalogViewController {
    private func setupViews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortButton)

        view.backgroundColor = .whiteDay
        view.setupView(catalogNFTTableView)
    }
}

// MARK: - Setup Constraints:
extension CatalogViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            catalogNFTTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            catalogNFTTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            catalogNFTTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            catalogNFTTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)])
    }
}

// MARK: - Setup Targets:
extension CatalogViewController {
    private func setupTargets() {
        sortButton.addTarget(self, action: #selector(sortButtonTarget), for: .touchUpInside)
    }
}
