import UIKit

final class ProfileViewModel: ProfileViewModelProtocol {

    // MARK: - Private Dependencies:
    private var dataProvider: DataProviderProtocol?

    // MARK: - Observable Values:
    var profileObservable: Observable<Profile?> {
        $profile
    }

    @Observable
    private(set) var profile: Profile?

    // MARK: - Lifecycle:
    init(dataProvider: DataProviderProtocol?) {
        self.dataProvider = dataProvider
        fetchProfile()
    }

    // MARK: - Private Methods:

    private func fetchProfile() {
        dataProvider?.fetchProfile(completion: { [weak self] result in
            switch result {
            case .success(let profile):
                self?.profile = profile
            case .failure(let failure):
                print(failure)
            }
        })
    }

    // MARK: - Public Methods:

    func changeProfile(profile: Profile) {
        dataProvider?.changeProfile(profile: profile, completion: { [weak self] result in
            switch result {
            case .success(let profile):
                self?.profile = profile
            case .failure(let failure):
                print(failure)
            }
        })
    }
}
