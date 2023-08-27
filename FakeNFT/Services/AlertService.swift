import UIKit
import YandexMobileMetrica

enum SortingOption: CaseIterable {
    case byName
    case byRating
    case byTitle
    case byPrice
    case byQuantity
    case close
    
    var localizedString: String {
        switch self {
        case .byName:
            return L10n.Sorting.byName
        case .byRating:
            return L10n.Sorting.byRating
        case .byTitle:
            return L10n.Sorting.byTitle
        case .byPrice:
            return L10n.Sorting.byPrice
        case .byQuantity:
            return L10n.Sorting.byNFTCount
        case .close:
            return L10n.General.close
        }
    }
    
    var sortingOptions: String {
        switch self {
        case .byName:
            return "byName"
        case .byRating:
            return "byRating"
        case .byTitle:
            return "byTitle"
        case .byPrice:
            return "byPrice"
        case .byQuantity:
            return "byQuantity"
        default:
            return ""
        }
    }
    
    init?(stringValue: String) {
        switch stringValue {
        case "byName":
            self = .byName
        case "byRating":
            self = .byRating
        case "byTitle":
            self = .byTitle
        case "byPrice":
            self = .byPrice
        case "byQuantity":
            self = .byQuantity
        default:
            return nil
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
    
    func showMetricaAlert(controller: UIViewController) {
        let alertController = UIAlertController(
            title: L10n.Metrica.warning,
            message: L10n.Metrica.message,
            preferredStyle: .alert)
        let agreeAction = UIAlertAction(title: L10n.Metrica.agree, style: .cancel) { _ in
            UserDefaultsService.shared.setNewAgreement(isAgree: true)
            YMMYandexMetrica.setStatisticsSending(true)
        }
        let cancelAction = UIAlertAction(title: L10n.Metrica.disagree, style: .default)
        
        alertController.addAction(cancelAction)
        alertController.addAction(agreeAction)
        
        controller.present(alertController, animated: true)
    }
}
