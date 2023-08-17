import UIKit

final class FavouritesNFTViewModel: FavouritesNFTViewModelProtocol {

    // MARK: - Private Dependencies:
    private var dataProvider: DataProviderProtocol?

    // MARK: - Observable Values:
    var nftCardsObservable: Observable<NFTCards?> {
        $nftCards
    }

    var usersObservable: Observable<Users?> {
        $users
    }

    @Observable
    private(set) var nftCards: NFTCards?

    @Observable
    private(set) var users: Users?

    // MARK: - Lifecycle:
    init(dataProvider: DataProviderProtocol?) {
        self.dataProvider = dataProvider
        fetchUsers()
    }

    // MARK: - Public Methods:
    func fetchNtfCards(likes: [String]) {
        dataProvider?.fetchUsersNFT(userId: nil, nftsId: likes) { [weak self] result in
            switch result {
            case .success(let nftCards):
                self?.nftCards = nftCards
            case .failure(let failure):
                print(failure)
            }
        }
    }

    // MARK: - Private Methods:

    private func fetchUsers() {
        dataProvider?.fetchUsers { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
