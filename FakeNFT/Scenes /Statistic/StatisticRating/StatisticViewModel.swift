import Foundation

final class StatisticViewModel: StatisticViewModelProtocol {
    
    // MARK: - Private classes
    private let dataProvider = DataProvider()
    
    // MARK: - Private properties
    private var sortingOption: SortingOption = .byRating
    
    // MARK: - Observable Properties
    var usersRatingObservable: Observable<UsersResponse> {
        $usersRating
    }
    @Observable
    private(set) var usersRating: UsersResponse = []
    
    // MARK: - Init
    init() {
        fetchUsersRating()
    }
    
    // MARK: - Public Functions
    func sortUsers(by type: SortingOption) {
        if sortingOption == type {
            return
        } else {
            sortingOption = type
        }
        
        switch type {
        case .byName:
            usersRating.sort { $1.name > $0.name }
        case .byRating:
            usersRating.sort { (Int($1.rating) ?? 0) > (Int($0.rating) ?? 0) }
        default:
            break
        }
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
