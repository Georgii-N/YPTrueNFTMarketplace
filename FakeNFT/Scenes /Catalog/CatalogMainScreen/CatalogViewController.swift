//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Евгений on 31.07.2023.
//

import UIKit
import Kingfisher

final class CatalogViewController: UIViewController {
    
    // MARK: - Private Dependencies:
    private var viewModel: CatalogViewModelProtocol?
    private var alertService: AlertServiceProtocol?
    
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupTargets()
        
        bind()
    }
    
    init(viewModel: CatalogViewModelProtocol?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods:
    private func bind() {
        viewModel?.nftCollectionsObservable.bind(action: { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.catalogNFTTableView.reloadData()
            }
        })
    }
    
    private func sortNFT(_ sortOptions: SortingOption) {
        switch sortOptions {
        case .byName:
            print("SORT BY NAME")
        case .byQuantity:
            print("SORT BY QUANTITY")
        default:
            break
        }
        
        alertService = nil
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
    }
}

// MARK: - UITableViewDataSource
extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let collections = viewModel?.nftCollectionsObservable.wrappedValue
        return collections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        let cell: CatalogTableViewCell = tableView.dequeueReusableCell()
        
        if let collectionModel = viewModel.nftCollectionsObservable.wrappedValue?[indexPath.row] {
            cell.setupCollectionModel(model: collectionModel)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        180
    }
}

// MARK: - UITableViewDelegate
extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CatalogTableViewCell else { return }
        
        let collectionModel = cell.getCollectionModel()
        let catalogCollectionViewModel = CatalogCollectionViewModel(collection: collectionModel)
        let viewController = CatalogCollectionViewController(viewModel: catalogCollectionViewModel)
        
        navigationController?.pushViewController(viewController, animated: true)
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
