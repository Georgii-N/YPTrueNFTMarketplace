@testable import FakeNFT
import XCTest

final class StatisticRatingUnitTests: XCTestCase {
    let provider: DataProviderProtocol = DataProviderStub()

    let usersList: [UserResponse] = [
        UserResponse(name: "Alice", avatar: "avatar_url_alice", description: "Artist", website: "aliceart.com", nfts: ["nft1"], rating: "5", id: "user_id_alice"),
        UserResponse(name: "Eve", avatar: "avatar_url_eve", description: "Tech lover", website: "evebytes.net", nfts: ["nft6"], rating: "4", id: "user_id_eve"),
        UserResponse(name: "Bob", avatar: "avatar_url_bob", description: "Blockchain enthusiast", website: "bobcrypto.io", nfts: ["nft4"], rating: "6", id: "user_id_bob")
    ]

    func testSortingByRating() {
        // Given
        let statisticViewModel = StatisticViewModel(dataProvider: DataProviderStub())
        var users = usersList
        
        // When
        let usersSorted = statisticViewModel.sortUsersbyType(by: .byRating, usersList: users)

        // Then
        XCTAssertEqual(usersSorted[0].rating, "4")
        XCTAssertEqual(usersSorted[1].rating, "5")
        XCTAssertEqual(usersSorted[2].rating, "6")
    }

    func testSortingByName() {
        // Given
        let statisticViewModel = StatisticViewModel(dataProvider: DataProviderStub())
        var users = usersList
        
        // When
        let usersSorted = statisticViewModel.sortUsersbyType(by: .byName, usersList: users)

        // Then
        XCTAssertEqual(usersSorted[0].name, "Alice")
        XCTAssertEqual(usersSorted[1].name, "Bob")
        XCTAssertEqual(usersSorted[2].name, "Eve")
    }
}
