import Foundation

final class StatisticNFTCollectionViewModel: StatisticNFTCollectionViewModelProtocol {
    
    // MARK: - Private classes
    private let dataProvider = DataProvider()
    
    // MARK: - Property Wrappers
    @Observable
    private(set) var usersRating: [User] = []
    
    // MARK: - Init
    init() {
        fetchUsersRating()
    }
    
    // MARK: - Private Functions
    private func fetchUsersRating() {
        dataProvider.fetchUsersRating { [weak self] result in
            switch result {
            case .success(let users):
                self?.usersRating = users
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
