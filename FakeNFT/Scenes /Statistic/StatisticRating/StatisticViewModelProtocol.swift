import Foundation

protocol StatisticViewModelProtocol {
    var usersRatingObservable: Observable<[User]> { get }
    
    func fetchNextPage()
}
