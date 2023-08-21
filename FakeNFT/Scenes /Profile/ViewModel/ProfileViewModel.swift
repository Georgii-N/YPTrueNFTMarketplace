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
    var showErrorAlert: ((String) -> Void)?

    // MARK: - Lifecycle:
    init(dataProvider: DataProviderProtocol?) {
        self.dataProvider = dataProvider
        fetchProfile()
    }

    // MARK: - Private Methods:

    func fetchProfile() {
        dataProvider?.fetchProfile(completion: { [weak self] result in
            switch result {
            case .success(let profile):
                self?.profile = profile
            case .failure(let failure):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: failure)
                self?.showErrorAlert?(errorString ?? "")
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
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: failure)
                self?.showErrorAlert?(errorString ?? "")
            }
        })
    }
}
