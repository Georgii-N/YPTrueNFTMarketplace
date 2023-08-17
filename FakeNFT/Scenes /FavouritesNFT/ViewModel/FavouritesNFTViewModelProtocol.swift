import UIKit

protocol FavouritesNFTViewModelProtocol: AnyObject {

    var nftCardsObservable: Observable<NFTCards?> { get }
    var usersObservable: Observable<Users?> { get }

    func fetchNtfCards(likes: [String])
}
