
import Foundation

protocol CartViewModelProtocol: AnyObject {
    var cartNft: Observable<[NFTCard]?> {get}
    func getOrder()
    func sendDeleteNft(id: String, completion: @escaping (Bool) -> Void)
    func getNfts()
    func additionNFT() -> Int
    func additionPriceNFT() -> Float
    func sortNFT(_ sortOptions: SortingOption)
    func unwrappedCartNftViewModel() -> [NFTCard]
}

final class CartViewModel: CartViewModelProtocol {
    
    
    // MARK: constants and variables
    private let dataProvider = DataProvider()
    private var idNfts: [String] = []
    var cartNft: Observable<[NFTCard]?> {
        $cartNFT
    }
    
    // MARK: Dependencies
    private var orderID: String?
    
    // MARK: Observable constants and variables
    @Observable
    private(set) var cartNFT: [NFTCard]?  = []
    
    // MARK: Init
    init() {
        getOrder()
    }
    
    // MARK: Methods
    func getOrder() {
        dataProvider.fetchOrder { result in
            switch result {
            case .success(let data):
                data.nfts.forEach { self.idNfts.append($0) }
                self.orderID = data.id
                self.getNfts()
            case .failure(let error):
                assertionFailure(error.localizedDescription)
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
        dataProvider.putNewOrder(order: newOrder) { result in
            switch result {
            case .success(let data):
                self.idNfts = []
                self.cartNFT = []
                data.nfts.forEach { self.idNfts.append($0) }
                self.orderID = data.id
                self.getNfts()
                completion(true)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    func getNfts() {
        dataProvider.fetchUsersNFT(userId: nil, nftsId: idNfts) {result in
            switch result {
            case .success(let data):
                data.forEach {self.cartNFT?.append($0)}
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    func additionNFT() -> Int {
        let cartNFT = unwrappedCartNftViewModel()
        return cartNFT.count
    }
    
    func additionPriceNFT() -> Float {
        let cartNFT = unwrappedCartNftViewModel()
        return Float(cartNFT.reduce(0) {$0 + $1.price})
    }
    
    func sortNFT(_ sortOptions: SortingOption) {
        var newNftCart: [NFTCard] = []
        let cartNFT = unwrappedCartNftViewModel()
        switch sortOptions {
        case .byPrice: newNftCart = cartNFT.sorted(by: {$0.price < $1.price})
        case .byRating: newNftCart = cartNFT.sorted(by: {$0.rating < $1.rating})
        case .byName: newNftCart = cartNFT.sorted(by: {$0.name < $1.name})
        default: break
        }
        self.cartNFT = newNftCart
    }
    
     func unwrappedCartNftViewModel() -> [NFTCard] {
        let cartNFT: [NFTCard] = []
        if let cartNFT = self.cartNft.wrappedValue {
            return cartNFT
        }
        return cartNFT
    }
}
