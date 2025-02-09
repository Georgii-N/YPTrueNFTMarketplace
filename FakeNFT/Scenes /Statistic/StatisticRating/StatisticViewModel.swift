import Foundation

final class StatisticViewModel: StatisticViewModelProtocol {
    
    // MARK: - Private classes
    private let dataProvider: DataProviderProtocol?
    
    // MARK: - Private properties
    private var sortingOption: SortingOption = .byRating
    
    // MARK: - Observable Properties
    var usersRatingObservable: Observable<UsersResponse> {
        $usersRating
    }
    
    var networkErrorObservable: Observable<String?> {
        $networkError
    }
    
    @Observable
    private(set) var usersRating: UsersResponse = []
    
    @Observable
    private(set) var networkError: String?
    
    // MARK: - Init
    init(dataProvider: DataProviderProtocol) {
        self.dataProvider = dataProvider
        getSortingOption()
    }
    
    // MARK: - Public Functions
    func sortUsers(by type: SortingOption, usersList: UsersResponse) {
        self.sortingOption = type
        saveSortingOption()
        let users = sortUsersbyType(by: type, usersList: usersList)
        self.usersRating = users
    }
    
    func sortUsersbyType(by type: SortingOption, usersList: UsersResponse) -> UsersResponse {
        let users = usersList
        switch type {
        case .byName:
            return users.sorted { $1.name > $0.name }
        case .byRating:
            return users.sorted { (Int($1.rating) ?? 0) > (Int($0.rating) ?? 0) }
        default:
            return []
        }
    }
    
    func saveSortingOption() {
        UserDefaultsService.shared.saveSortingOption(sortingOption, forScreen: .statistic)
    }
    
    // MARK: - Private Functions
    func fetchUsersRating() {
        dataProvider?.fetchUsersRating { [weak self] result in
            switch result {
            case .success(let users):
                self?.sortUsers(by: self?.sortingOption ?? .byRating, usersList: users)
            case .failure(let error):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: error)
                self?.networkError = errorString
            }
        }
    }
    
    private func getSortingOption() {
        if let option = UserDefaultsService.shared.getSortingOption(for: .statistic) {
            self.sortingOption = option
        }
    }
}
