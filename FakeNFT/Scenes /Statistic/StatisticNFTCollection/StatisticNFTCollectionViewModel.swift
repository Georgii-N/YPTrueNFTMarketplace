import Foundation

final class StatisticNFTCollectionViewModel: StatisticNFTCollectionViewModelProtocol {
    
    // MARK: - Private classes
    private let dataProvider: DataProviderProtocol?
    
    // MARK: - Private Constants and Variables
    private let nftsId: [String]
    private var profile: Profile?
    private var order: Order?
    
    // MARK: - Observable Properties
    var nftsObservable: Observable<NFTCells> {
        $NFTcards
    }
    
    var likeStatusDidChangeObservable: Observable<Bool> {
        $likeStatusDidChange
    }
    
    var cartStatusDidChangeObservable: Observable<Bool> {
        $cartStatusDidChange
    }
    
    var networkErrorObservable: Observable<String?> {
        $networkError
    }
    
    @Observable
    private(set) var NFTcards: NFTCells = []
    
    @Observable
    private(set) var likeStatusDidChange = false
    
    @Observable
    private(set) var cartStatusDidChange = false
    
    @Observable
    private(set) var networkError: String?
    
    // MARK: - Init
    init(nftsId: [String], dataProvider: DataProviderProtocol) {
        self.nftsId = nftsId
        self.dataProvider = dataProvider
    }
    
    // MARK: - Private Functions
    func fetchUsersNFT() {
        dataProvider?.fetchUsersNFT(userId: nil, nftsId: nftsId) { [weak self] result in
            switch result {
            case .success(let result):
                self?.NFTcards = result.map({
                    let isLiked = self?.profile?.likes.contains($0.id)
                    let isAddedToCart = self?.order?.nfts.contains($0.id)
                    return NFTCell(name: $0.name,
                                   images: $0.images,
                                   rating: $0.rating,
                                   price: $0.price,
                                   author: $0.author,
                                   id: $0.id,
                                   isLiked: isLiked ?? false,
                                   isAddedToCard: isAddedToCart ?? false)
                })
            case .failure(let error):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: error)
                self?.networkError = errorString
            }
        }
    }
    
    private func fetchProfile() {
        dataProvider?.fetchProfile(completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
            case .failure(let error):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: error)
                self.networkError = errorString
            }
        })
    }
    
    private func fetchOrder() {
        dataProvider?.fetchOrder(completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let order):
                self.order = order
            case .failure(let error):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: error)
                self.networkError = errorString
            }
        })
    }
    
    func changeNFTCartStatus(isAddedToCart: Bool, id: String) {
        guard var newOrderID = order?.nfts else { return }
        
        if !isAddedToCart {
            newOrderID.append(id)
        } else {
            guard let index = newOrderID.firstIndex(where: { $0 == id }) else { return }
            newOrderID.remove(at: index)
        }
        
        guard var order = order else { return }
        order = Order(nfts: newOrderID, id: "1")
        
        dataProvider?.putNewOrder(order: order, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.cartStatusDidChange = true
                self.order = order
            case .failure(let error):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: error)
                self.networkError = errorString
            }
        })
    }
    
    func changeNFTFavouriteStatus(isLiked: Bool, id: String) {
        guard var newLikes = profile?.likes else { return }
        
        if !isLiked {
            newLikes.append(id)
        } else {
            guard let index = newLikes.firstIndex(where: { $0 == id }) else { return }
            newLikes.remove(at: index)
        }
        
        guard var profile = profile else { return }
        profile = Profile(name: profile.name,
                          avatar: profile.avatar,
                          description: profile.description,
                          website: profile.website,
                          nfts: profile.nfts,
                          likes: newLikes,
                          id: profile.id)
        
        dataProvider?.putNewProfile(profile: profile, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.likeStatusDidChange = true
                self.profile = profile
            case .failure(let error):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: error)
                self.networkError = errorString
            }
        })
    }
    
    func getData() {
        fetchOrder()
        fetchProfile()
        fetchUsersNFT()
    }
}
