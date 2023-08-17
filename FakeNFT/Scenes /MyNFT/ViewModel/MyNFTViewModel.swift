import UIKit

final class MyNFTViewModel: MyNFTViewModelProtocol {

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
    func fetchNtfCards(nftIds: [String]) {
        dataProvider?.fetchUsersNFT(userId: nil, nftsId: nftIds) { [weak self] result in
            switch result {
            case .success(let nftCards):
                self?.nftCards = nftCards
            case .failure(let failure):
                print(failure)
            }
        }
    }

    func sortNFTCollection(option: SortingOption) {
        guard let nftCards = nftCards else { return }

        var cards = [NFTCard]()

        switch option {
        case .byPrice:
            cards = nftCards.sorted(by: { $0.price < $1.price })
        case .byRating:
            cards = nftCards.sorted { nft1, nft2 in
                nft1.rating > nft2.rating
            }
        case .byName:
            cards = nftCards.sorted { nft1, nft2 in
                nft1.name < nft2.name
            }
        default:
            break
        }

        self.nftCards = cards
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
