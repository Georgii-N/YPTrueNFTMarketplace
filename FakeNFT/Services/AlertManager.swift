//
//  AlertManager.swift
//  FakeNFT
//
//  Created by Тихтей  Павел on 19.08.2023.
//

import UIKit

class AlertManager {
    static func showNetworkErrorAlert(on viewController: UIViewController, message: String) {
        let alert = UIAlertController(title: "Network Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
