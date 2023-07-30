//
//  AlertService.swift
//  FakeNFT
//
//  Created by Евгений on 28.07.2023.
//

import UIKit

final class AlertService {
    
    func showAlert(title: String?,
                   message: String?,
                   preferredStyle: UIAlertController.Style,
                   controller: UIViewController,
                   completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title ?? nil,
                                      message: message ?? nil,
                                      preferredStyle: preferredStyle)
        let okAction = UIAlertAction(title: "OK", style: .default)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        controller.present(alert, animated: true)
    }
    
    
}
