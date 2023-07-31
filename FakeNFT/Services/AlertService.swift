import UIKit

enum SortingOption: CaseIterable {
    case byName
    case byPrice
    case byRating
    case byQuantity
    case close
    
    var localizedString: String {
        switch self {
        case .byName:
            return L10n.Alert.Sort.byName
        case .byPrice:
            return L10n.Alert.Sort.byPrice
        case .byRating:
            return L10n.Alert.Sort.byRating
        case .byQuantity:
            return L10n.Alert.Sort.byNumberOfNFT
        case .close:
            return L10n.General.close
        }
    }
}

protocol AlertServiceProtocol {
    func showActionSheet(title: String?, sortingOptions: [SortingOption], on viewController: UIViewController, completion: @escaping (SortingOption) -> Void)
}

class UniversalAlertService: AlertServiceProtocol {
    func showActionSheet(title: String?, sortingOptions: [SortingOption], on viewController: UIViewController, completion: @escaping (SortingOption) -> Void) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        for option in sortingOptions {
            if option == .close {
                
                let action = UIAlertAction(title: option.localizedString, style: .cancel) { _ in
                    completion(option)
                }
                alertController.addAction(action)
            } else {
                let action = UIAlertAction(title: option.localizedString, style: .default) { _ in
                    completion(option)
                }
                alertController.addAction(action)
            }
        }
        viewController.present(alertController, animated: true, completion: nil)
    }
}
