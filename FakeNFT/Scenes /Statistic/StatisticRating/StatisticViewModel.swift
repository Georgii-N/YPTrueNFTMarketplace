import Foundation

final class StatisticViewModel: StatisticViewModelProtocol {
    
    // MARK: - Private classes
    private let dataProvider = DataProvider()
    
    // MARK: - Private properties
    private var currentPage = 1
    private var sortingOption: SortingOption = .byRating
    
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
    
    func sortUsers(by type: SortingOption) {
        sortingOption = type
        
        switch type {
        case .byName:
            usersRating.sort { (user1, user2) -> Bool in
                return user1.name < user2.name
            }
        case .byRating:
            usersRating.sort { (user1, user2) -> Bool in
                return user1.rating > user2.rating
            }
        default:
            break
        }
    }
    
    // MARK: - Private Functions
    private func fetchUsersRating() {
        dataProvider.fetchUsersRating(page: currentPage) { [weak self] result in
            switch result {
            case .success(let users):
                self?.usersRating.append(contentsOf: users)
                self?.sortUsers(by: self?.sortingOption ?? .byRating)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
