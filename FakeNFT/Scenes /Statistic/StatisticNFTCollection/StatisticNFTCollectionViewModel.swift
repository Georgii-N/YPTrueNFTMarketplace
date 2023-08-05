import Foundation

final class StatisticNFTCollectionViewModel: StatisticNFTCollectionViewModelProtocol {
    
    // MARK: - Private classes
    private let dataProvider = DataProvider()
    
    // MARK: - Private constants
    private let userId: String
    
    // MARK: - Property Wrappers
    @Observable
    private(set) var NFTcards: NFTCards = []
    
    // MARK: - Init
    init(userId: String) {
        self.userId = userId
        fetchUsersNFT()
    }
    
    // MARK: - Private Functions
    private func fetchUsersNFT() {
        dataProvider.fetchUsersNFT(userId: userId, nftsId: nil) { [weak self] result in
            switch result {
            case .success(let result):
                self?.NFTcards = result
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
