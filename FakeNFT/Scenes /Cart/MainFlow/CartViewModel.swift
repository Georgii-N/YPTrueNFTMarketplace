import Foundation

protocol CartViewModelProtocol: AnyObject {
    var cartNft: Observable<[NFTCard]?> {get}
    var networkErrorObservable: Observable<String?> {get}
    func getOrder()
    func sendDeleteNft(id: String, completion: @escaping (Bool) -> Void)
    func additionNFT() -> Int
    func additionPriceNFT() -> String
    func sortNFT(_ sortOptions: SortingOption)
    func unwrappedCartNftViewModel() -> [NFTCard]
}

final class CartViewModel: CartViewModelProtocol {
    
    // MARK: constants and variables
    var cartNft: Observable<[NFTCard]?> {
        $cartNFT
    }
    
    var networkErrorObservable: Observable<String?> {
       return $networkError
    }
    
    private let dataProvider = DataProvider()
    private var idNfts: [String] = []
    private let userDefaults = UserDefaultsService.shared
    private lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        return formatter
    }()
    
    // MARK: Dependencies
    private var orderID: String?
    
    // MARK: Observable constants and variables
    @Observable
    private(set) var cartNFT: [NFTCard]?  = []
    
    @Observable
    private(set) var networkError: String?
        
    // MARK: Methods
    func getOrder() {
        dataProvider.fetchOrder {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                data.nfts.forEach { self.idNfts.append($0) }
                self.orderID = data.id
                self.getNfts()
            case .failure(let error):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: error)
                self.networkError = errorString
            }
        }
    }
    
    func sendDeleteNft(id: String, completion: @escaping (Bool) -> Void) {
        guard let orderId = orderID else { return }
        var newNftId: [String] = []
        cartNFT?.filter {nft in
            nft.id != id
        }.forEach {nft in
            newNftId.append(nft.id)
        }
        let newOrder = Order(nfts: newNftId, id: orderId)
        dataProvider.putNewOrder(order: newOrder) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.idNfts = []
                self.cartNFT = []
                data.nfts.forEach { self.idNfts.append($0) }
                self.orderID = data.id
                self.getNfts()
                completion(true)
            case .failure(let error):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: error)
                self.networkError = errorString
            }
        }
    }
        
    private func getNfts() {
        dataProvider.fetchUsersNFT(userId: nil, nftsId: idNfts) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                data.forEach {self.cartNFT?.append($0)}
                self.getSort()
            case .failure(let error):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: error)
                self.networkError = errorString
            }
        }
    }
    
    func additionNFT() -> Int {
        let cartNFT = unwrappedCartNftViewModel()
        return cartNFT.count
    }
    
    func additionPriceNFT() -> String {
        let cartNFT = unwrappedCartNftViewModel()
        let number = Float(cartNFT.reduce(0) {$0 + $1.price})
        if let formattedString = formatter.string(from: NSNumber(value: number)) {
            return formattedString
        }
        return String(cartNFT.reduce(0) {$0 + $1.price})
    }
    
    func sortNFT(_ sortOptions: SortingOption) {
        userDefaults.saveSortingOption(sortOptions, forScreen: .cart)
        var newNftCart: [NFTCard] = []
        let cartNFT = unwrappedCartNftViewModel()
        switch sortOptions {
        case .byPrice: newNftCart = cartNFT.sorted(by: {$0.price > $1.price})
        case .byRating: newNftCart = cartNFT.sorted(by: {$0.rating > $1.rating})
        case .byTitle: newNftCart = cartNFT.sorted(by: {$0.name < $1.name})
        case .close: newNftCart = cartNFT
        default: break
        }
        self.cartNFT = newNftCart
    }
    
   private func getSort() {
        if let userDefaulds = userDefaults.getSortingOption(for: .cart) {
            sortNFT(userDefaulds)
        } else {
            sortNFT(.byTitle)
        }
    }
    
     func unwrappedCartNftViewModel() -> [NFTCard] {
        let cartNFT: [NFTCard] = []
        if let cartNFT = self.cartNft.wrappedValue {
            return cartNFT
        }
        return cartNFT
    }
}
