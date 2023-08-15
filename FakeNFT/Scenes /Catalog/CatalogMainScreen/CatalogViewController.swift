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
    
    // MARK: - Private Classes:
    private var analyticsService = AnalyticsService.instance
    
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
    
    private lazy var refreshStubLabel = RefreshStubLabel()
    private lazy var sortButton = SortNavBarBaseButton()
    private lazy var refreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle
    init(viewModel: CatalogViewModelProtocol?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blockUI()

        setupViews()
        setupConstraints()
        setupTargets()
        
        bind()
        
        viewModel?.fetchCollections()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsService.sentEvent(screen: .catalogMain, item: .screen, event: .open)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.sentEvent(screen: .catalogMain, item: .screen, event: .close)
    }
    
    // MARK: - Private Methods:
    private func bind() {
        viewModel?.nftCollectionsObservable.bind { [weak self] _ in
            guard let self else { return }
            self.resumeMethodOnMainThread(self.unblockUI, with: ())
            self.resumeMethodOnMainThread(self.catalogNFTTableView.reloadData, with: ())
        }
        
        viewModel?.networkErrorObservable.bind { [weak self] errorText in
            guard let self else { return }
            if let errorText {
                self.resumeMethodOnMainThread(self.refreshControl.endRefreshing, with: ())
                self.resumeMethodOnMainThread(self.unblockUI, with: ())
                self.resumeMethodOnMainThread(self.showNotificationBanner, with: errorText)
            }
        }
    }
                                               
    private func sortNFT(_ sortOptions: SortingOption) {
        switch sortOptions {
        case .byTitle:
            viewModel?.sortNFTCollection(option: .byTitle)
        case .byQuantity:
            viewModel?.sortNFTCollection(option: .byQuantity)
        default:
            break
        }
        
        alertService = nil
    }
    
    private func setupStubLabel() {
        view.setupView(refreshStubLabel)

        NSLayoutConstraint.activate([
        refreshStubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        refreshStubLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func resumeMethodOnMainThread<T>(_ method: @escaping ((T) -> Void), with argument: T) {
        DispatchQueue.main.async {
            method(argument)
        }
    }
    
    // MARK: - Objc Methods:
    @objc private func sortButtonTarget() {
        alertService = UniversalAlertService()
        
        alertService?.showActionSheet(title: L10n.Sorting.title,
                                      sortingOptions: [.byTitle, .byQuantity, .close],
                                      on: self,
                                      completion: { [weak self] options in
            guard let self else { return }
            self.sortNFT(options)
        })
        
        analyticsService.sentEvent(screen: .catalogMain, item: .buttonSorting, event: .click)
    }
    
    @objc private func refreshNFTCatalog() {
        blockUI()
        viewModel?.fetchCollections()
        analyticsService.sentEvent(screen: .catalogMain, item: .pullToRefresh, event: .click)
    }
}

// MARK: - UITableViewDataSource
extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let collections = viewModel?.nftCollectionsObservable.wrappedValue

        if collections == nil {
            setupStubLabel()
        } else {
            refreshStubLabel.removeFromSuperview()
        }
        
        return collections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel else { return UITableViewCell() }
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
        guard let cell = tableView.cellForRow(at: indexPath) as? CatalogTableViewCell,
              let viewModel else { return }
        
        let collectionModel = cell.getCollectionModel()
        let dataProvider = viewModel.provider
        let catalogCollectionViewModel = CatalogCollectionViewModel(dataProvider: dataProvider, collection: collectionModel)
        let viewController = CatalogCollectionViewController(viewModel: catalogCollectionViewModel)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - Setup Views:
extension CatalogViewController {
    private func setupViews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortButton)
        setupBackButtonItem()
        
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
