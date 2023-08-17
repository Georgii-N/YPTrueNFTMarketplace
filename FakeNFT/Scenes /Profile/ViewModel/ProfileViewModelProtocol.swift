import UIKit

protocol ProfileViewModelProtocol: AnyObject {

    var profileObservable: Observable<Profile?> { get }

    func changeProfile(profile: Profile)
}
