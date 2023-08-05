import Foundation

protocol StatisticViewModelProtocol {
    var usersRatingObservable: Observable<[User]> { get }
    
    func fetchNextPage()
    func sortUsers(by type: SortingOption)
}
