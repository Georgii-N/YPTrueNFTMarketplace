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
    
    private lazy var stubRefreshLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "Кажется,что ничего нет\nПотяните вниз чтобы обновить"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 15)
        
        return label
    }()
    
    private lazy var sortButton = SortNavBarBaseButton()
    private lazy var refreshControl = UIRefreshControl()
        
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupTargets()
        blockUI()
        
        bind()
        
        viewModel?.fetchCollections()
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
                self.unblockUI()
                self.catalogNFTTableView.reloadData()
            }
        })
        
        viewModel?.networkErrorObservable.bind(action: { [weak self] errorText in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if errorText == nil {
                    self.unblockUI()
                } else {
                    self.refreshControl.endRefreshing()
                    self.unblockUI()
                    self.showNotificationBanner(with: errorText ?? "")
                }
            }
        })
    }
                                               
    private func sortNFT(_ sortOptions: SortingOption) {
        switch sortOptions {
        case .byName:
            viewModel?.sortNFTCollection(option: .byName)
        case .byQuantity:
            viewModel?.sortNFTCollection(option: .byQuantity)
        default:
            break
        }
        
        alertService = nil
    }
    
    private func setupStubLabel() {
        view.setupView(stubRefreshLabel)

        NSLayoutConstraint.activate([
        stubRefreshLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        stubRefreshLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
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
    
    @objc private func refreshNFTCatalog() {
        blockUI()
        viewModel?.fetchCollections()
    }
}

// MARK: - UITableViewDataSource
extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let collections = viewModel?.nftCollectionsObservable.wrappedValue

        if collections == nil {
            setupStubLabel()
        } else {
            stubRefreshLabel.removeFromSuperview()
        }
        return collections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        let cell: CatalogTableViewCell = tableView.dequeueReusableCell()
        
        if let collectionModel = viewModel.nftCollectionsObservable.wrappedValue?[indexPath.row] {
            tableView.isHidden = false
            cell.setupCollectionModel(model: collectionModel)
            refreshControl.endRefreshing()
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
        
        catalogNFTTableView.refreshControl = refreshControl
    }
}

// MARK: - Setup Constraints:
extension CatalogViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            catalogNFTTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            catalogNFTTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            catalogNFTTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            catalogNFTTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

// MARK: - Setup Targets:
extension CatalogViewController {
    private func setupTargets() {
        sortButton.addTarget(self, action: #selector(sortButtonTarget), for: .touchUpInside)
        refreshControl.addTarget(self, action: #selector(refreshNFTCatalog), for: .valueChanged)
    }
}
