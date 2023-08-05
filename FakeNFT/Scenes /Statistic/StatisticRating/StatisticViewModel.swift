import Foundation

final class StatisticViewModel: StatisticViewModelProtocol {
    
    // MARK: - Private classes
    private let dataProvider = DataProvider()
    
    // MARK: - Private constants
    private var currentPage = 1
    
    // MARK: - Property Wrappers
    @Observable
    private(set) var usersRating: [User] = []
    
    // MARK: - Init
    init() {
        fetchUsersRating()
    }
    
    // MARK: - Private Functions
    private func fetchUsersRating() {
        dataProvider.fetchUsersRating(page: currentPage) { [weak self] result in
            switch result {
            case .success(let users):
                self?.usersRating = users
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
