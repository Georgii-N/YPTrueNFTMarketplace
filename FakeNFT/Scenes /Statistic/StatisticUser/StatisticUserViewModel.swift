import Foundation

final class StatisticUserViewModel {
    
    // MARK: - Private classes
    private let dataProvider = DataProvider()
    
    // MARK: - Private constants
    private let profileId: String
    private let userNFTs: [String]
    
    // MARK: - Property Wrappers
    @Observable
    private(set) var profile: UsersResponse = []
    
    // MARK: - Init
    init(profileId: String, userNFTs: [String]) {
        self.profileId = profileId
        self.userNFTs = userNFTs
        fetchProfileId()
    }
    
    // MARK: - Private Functions
    private func fetchProfileId() {
        dataProvider.fetchUserID(userId: profileId) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.profile.append(profile)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
