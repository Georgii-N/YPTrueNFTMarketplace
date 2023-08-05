import Foundation

final class StatisticViewModel: StatisticViewModelProtocol {
    
    // MARK: - Private classes
    private let dataProvider = DataProvider()
    
    // MARK: - Private properties
    private var currentPage = 1
    
    // MARK: - Observable Properties
    var usersRatingObservable: Observable<[User]> {
            $usersRating
        }
    @Observable
    private(set) var usersRating: [User] = []
    
    // MARK: - Init
    init() {
        fetchUsersRating()
    }
    
    // MARK: - Public Functions
    func fetchNextPage() {
        currentPage += 1
        fetchUsersRating()
    }
    
    // MARK: - Private Functions
    private func fetchUsersRating() {
        dataProvider.fetchUsersRating(page: currentPage) { [weak self] result in
            switch result {
            case .success(let users):
                self?.usersRating.append(contentsOf: users)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
