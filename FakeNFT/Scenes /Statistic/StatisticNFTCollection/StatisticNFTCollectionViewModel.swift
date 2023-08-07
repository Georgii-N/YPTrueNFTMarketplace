import Foundation

final class StatisticNFTCollectionViewModel: StatisticNFTCollectionViewModelProtocol {
    
    // MARK: - Private classes
    private let dataProvider = DataProvider()
    
    // MARK: - Private constants
    private let nftsId: [String]
    
    // MARK: - Property Wrappers
    @Observable
    private(set) var NFTcards: NFTCards = []
    
    // MARK: - Init
    init(nftsId: [String]) {
        self.nftsId = nftsId
        fetchUsersNFT()
    }
    
    // MARK: - Private Functions
    private func fetchUsersNFT() {
        dataProvider.fetchUsersNFT(userId: nil, nftsId: nftsId) { [weak self] result in
            switch result {
            case .success(let result):
                self?.NFTcards = result
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
