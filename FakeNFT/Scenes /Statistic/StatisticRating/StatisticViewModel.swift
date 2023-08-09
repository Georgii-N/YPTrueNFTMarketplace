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
        getSortingOption()
        fetchUsersRating()
    }
    
    // MARK: - Public Functions
    func sortUsers(by type: SortingOption, usersList: UsersResponse) {
        self.sortingOption = type
        var users = usersList
        switch type {
        case .byName:
            users.sort { $1.name > $0.name }
        case .byRating:
            users.sort { (Int($1.rating) ?? 0) > (Int($0.rating) ?? 0) }
        default:
            break
        }
        
        self.usersRating = users
    }
    
    func saveSortingOption() {
        UserDefaultsService.shared.saveSortingOption(sortingOption, forScreen: .statistic)
    }
    
    // MARK: - Private Functions
    private func fetchUsersRating() {
        dataProvider.fetchUsersRating { [weak self] result in
            switch result {
            case .success(let users):
                self?.sortUsers(by: self?.sortingOption ?? .byRating, usersList: users)
               
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    private func getSortingOption() {
        if let option = UserDefaultsService.shared.getSortingOption(for: .statistic) {
            self.sortingOption = option
        }
    }
}
