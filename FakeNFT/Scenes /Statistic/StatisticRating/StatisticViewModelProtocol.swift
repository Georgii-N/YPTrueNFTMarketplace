import Foundation

protocol StatisticViewModelProtocol {
    var usersRatingObservable: Observable<UsersResponse> { get }
    
    func sortUsers(by type: SortingOption)
}
