//
//  CustomNavigationController.swift
//  FakeNFT
//
//  Created by Евгений on 30.07.2023.
//

import UIKit

final class CustomNavigationController: UINavigationController {
  
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.backgroundColor = .whiteDay
        navigationBar.tintColor = .blackDay
    }
}
