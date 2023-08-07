import UIKit

final class StatisticNFTCollectionViewController: UIViewController {
    
    // MARK: - Private Dependencies
    private var statisticNFTViewModel: StatisticNFTCollectionViewModel
    
    // MARK: - Private Properties
    private var indexPathToUpdateNFTCell: IndexPath?
    
    // MARK: - UI
    private lazy var collectionView: NFTCollectionView = {
        let collectionView = NFTCollectionView()
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var stubLabel: UILabel = {
        let stubLabel = UILabel()
        stubLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        stubLabel.textColor = .blackDay
        stubLabel.textAlignment = .center
        stubLabel.text = L10n.Statistic.Profile.UserCollection.stub
        stubLabel.isHidden = true
        return stubLabel
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        setupUI()
        bind()
        blockUI()
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
                self.unblockUI()
                self.collectionView.reloadData()
                self.showStub()
            }
        }
    }
    
    private func showStub() {
        if statisticNFTViewModel.NFTcards.count == 0 {
            stubLabel.isHidden = false
        }
    }
    
    private func setupViews() {
        view.setupView(collectionView)
        view.setupView(stubLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
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
        cell.delegate = self
        let NFTCellModel = NFTCell(name: statisticNFTViewModel.NFTcards[indexPath.row].name,
                                   images: statisticNFTViewModel.NFTcards[indexPath.row].images,
                                   rating: Int(statisticNFTViewModel.NFTcards[indexPath.row].rating),
                                   price: statisticNFTViewModel.NFTcards[indexPath.row].price,
                                   author: statisticNFTViewModel.NFTcards[indexPath.row].author,
                                   id: statisticNFTViewModel.NFTcards[indexPath.row].id,
                                   isLiked: statisticNFTViewModel.NFTcards[indexPath.row].isLiked,
                                   isAddedToCard: statisticNFTViewModel.NFTcards[indexPath.row].isLiked)
        
        cell.setupNFTModel(model: NFTCellModel)
        return cell
    }
}

// MARK: - DelegateFlowLayout
extension StatisticNFTCollectionViewController: UICollectionViewDelegateFlowLayout {
    
}

// MARK: - NFTCollectionCellDelegate
extension StatisticNFTCollectionViewController: NFTCollectionCellDelegate {
    func likeButtonDidTapped(cell: NFTCollectionCell) {
        //
    }
    
    func addToCardButtonDidTapped(cell: NFTCollectionCell) {
        //
    }
    
    
}
