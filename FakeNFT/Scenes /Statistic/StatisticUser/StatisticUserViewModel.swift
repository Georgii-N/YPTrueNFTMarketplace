import Foundation

final class StatisticUserViewModel {
    
    // MARK: - Private classes
    private let dataProvider = DataProvider()
    
    // MARK: - Private constants
    private let profileId: String
    
    // MARK: - Property Wrappers
    @Observable
    private(set) var profile: UsersResponse = []
    
    // MARK: - Init
    init(profileId: String) {
        self.profileId = profileId
        fetchProfileId()
    }
    
    // MARK: - Private Functions
    private func fetchProfileId() {
        dataProvider.fetchProfileId(userId: profileId) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.profile.append(profile)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
