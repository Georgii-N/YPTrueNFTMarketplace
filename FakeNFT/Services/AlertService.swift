//
//  AlertService.swift
//  FakeNFT
//
//  Created by Евгений on 28.07.2023.
//

import UIKit

final class AlertService {
    
    enum TypeOfEvent {
        case catalog
        case statistic
    }
    
    func showAuthorizationAlert(controller: UIViewController) {
        
        let alert = UIAlertController(title: L10n.Alert.Authorization.title,
                                      message: L10n.Alert.Authorization.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: L10n.General.ok, style: .default)
        
        alert.addAction(action)
        
        controller.present(alert, animated: true)
    }
    
    func showCatalogSortAlert(controller: UIViewController,
                              event: TypeOfEvent,
                              topCompletion: @escaping () -> Void,
                              bottomCompletion: @escaping () -> Void) {
        
        var topActionTitle = ""
        var bottomActionTitle = ""
        
        switch event {
        case .catalog:
            topActionTitle = L10n.Alert.Sort.byNameOfNFT
            bottomActionTitle = L10n.Alert.Sort.byNumberOfNFT
        case .statistic:
            topActionTitle = L10n.Alert.Sort.byName
            bottomActionTitle = L10n.Alert.Sort.byRating
        }
        
        let alert = UIAlertController(title: L10n.Alert.sortTitle,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        let topAction = UIAlertAction(title: topActionTitle, style: .default) { _ in
            topCompletion()
        }
        let bottomAction = UIAlertAction(title: bottomActionTitle, style: .default) { _ in
            bottomCompletion()
        }
        let closeAction = UIAlertAction(title: L10n.General.close, style: .cancel)
        
        alert.addAction(topAction)
        alert.addAction(bottomAction)
        alert.addAction(closeAction)
        
        controller.present(alert, animated: true)
    }
    
    func showCartAndProfileAlert(controller: UIViewController,
                                 sortPriceCompletion: @escaping () -> Void,
                                 sortRatingCompletion: @escaping () -> Void,
                                 sortNameCompletion: @escaping () -> Void) {
        
        let alert = UIAlertController(title: L10n.Alert.sortTitle,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        let sortByPriceAction = UIAlertAction(title: L10n.Alert.Sort.byPrice, style: .default) { _ in
            sortPriceCompletion()
        }
        
        let sortByRatingAction = UIAlertAction(title: L10n.Alert.Sort.byRating, style: .default) { _ in
            sortRatingCompletion()
        }
        
        let sortByNameAction = UIAlertAction(title: L10n.Alert.Sort.byName, style: .default) { _ in
            sortNameCompletion()
        }
        
        let closeAction = UIAlertAction(title: L10n.General.close, style: .cancel)
        
        alert.addAction(sortByPriceAction)
        alert.addAction(sortByRatingAction)
        alert.addAction(sortByNameAction)
        alert.addAction(closeAction)
        
        controller.present(alert, animated: true)
    }
}
