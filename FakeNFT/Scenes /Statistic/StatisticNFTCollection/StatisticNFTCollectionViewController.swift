import UIKit

final class StatisticNFTCollectionViewController: UIViewController {
    
    // MARK: - Private Dependencies
    private var statisticNFTViewModel: StatisticNFTCollectionViewModel
    
    // MARK: - UI
    private lazy var collectionView: NFTCollectionView = {
        let collectionView = NFTCollectionView()
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        setupUI()
        bind()
    }
    
    // MARK: - Init
    init(statisticNFTViewModel: StatisticNFTCollectionViewModel) {
        self.statisticNFTViewModel = statisticNFTViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Functions
extension StatisticNFTCollectionViewController {
    
    private func bind() {
        statisticNFTViewModel.$NFTcards.bind { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private func setupViews() {
        view.setupView(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        self.title = L10n.Statistic.Profile.ButtonCollection.title
    }
}

// MARK: - DataSource
extension StatisticNFTCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        statisticNFTViewModel.NFTcards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NFTCollectionCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.setupNFTModel(model: statisticNFTViewModel.NFTcards[indexPath.row])
        return cell
    }
}

// MARK: - DelegateFlowLayout
extension StatisticNFTCollectionViewController: UICollectionViewDelegateFlowLayout {
    
}
