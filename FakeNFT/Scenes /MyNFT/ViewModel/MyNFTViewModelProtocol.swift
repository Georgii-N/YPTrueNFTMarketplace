import UIKit

protocol MyNFTViewModelProtocol: AnyObject {

    var nftCardsObservable: Observable<NFTCards?> { get }
    var usersObservable: Observable<Users?> { get }

    func fetchNtfCards(nftIds: [String])
    func sortNFTCollection(option: SortingOption)
}
