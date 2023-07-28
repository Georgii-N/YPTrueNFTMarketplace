//
//  Resources.swift
//  FakeNFT
//
//  Created by Евгений on 28.07.2023.
//

import UIKit

enum Resources {
    enum Images {
        enum TabBar {
            static let profileImage = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.blackDay, renderingMode: .alwaysOriginal)
            static let profileImageSelected = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.blueUniversal, renderingMode: .alwaysOriginal)

            static let catalogImage = UIImage(named: "Catalog")?.withTintColor(.blackDay, renderingMode: .alwaysOriginal)
            static let catalogImageSelected = UIImage(named: "Catalog")?.withTintColor(.blueUniversal, renderingMode: .alwaysOriginal)

            static let cartImage = UIImage(named: "TrashBasket")?.withTintColor(.blackDay, renderingMode: .alwaysOriginal)
            static let cartImageSelected = UIImage(named: "TrashBasket")?.withTintColor(.blueUniversal, renderingMode: .alwaysOriginal)

            static let statisticImage = UIImage(systemName: "flag.2.crossed.fill")?.withTintColor(.blackDay, renderingMode: .alwaysOriginal)
            static let statisticImageSelected = UIImage(systemName: "flag.2.crossed.fill")?.withTintColor(.blueUniversal, renderingMode: .alwaysOriginal)
        }
    }
}
