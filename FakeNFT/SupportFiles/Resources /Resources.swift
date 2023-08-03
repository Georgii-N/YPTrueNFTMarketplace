import UIKit

enum Resources {
    enum Images {
        enum TabBar {
            static let profileImage = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.blackDay, renderingMode: .alwaysOriginal)
            static let profileImageSelected = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.blueUniversal, renderingMode: .alwaysOriginal)
            
            static let catalogImage = UIImage(named: "Catalog")?.withTintColor(.blackDay, renderingMode: .alwaysOriginal)
            static let catalogImageSelected = UIImage(named: "Catalog")?.withTintColor(.blueUniversal, renderingMode: .alwaysOriginal)
            
            static let cartImage = UIImage(named: "cartBasket")?.withTintColor(.blackDay, renderingMode: .alwaysOriginal)
            static let cartImageSelected = UIImage(named: "cartBasket")?.withTintColor(.blueUniversal, renderingMode: .alwaysOriginal)
            
            static let statisticImage = UIImage(systemName: "flag.2.crossed.fill")?.withTintColor(.blackDay, renderingMode: .alwaysOriginal)
            static let statisticImageSelected = UIImage(systemName: "flag.2.crossed.fill")?.withTintColor(.blueUniversal, renderingMode: .alwaysOriginal)
        }
        
        enum NavBar {
            static let sortIcon = UIImage(named: "sort")
        }
        
        enum NFTCollectionCell {
            static let unlikedButton = UIImage(systemName: "heart.fill")?.withTintColor(.whiteUniversal, renderingMode: .alwaysOriginal)
            static let likedButton = UIImage(systemName: "heart.fill")?.withTintColor(.redUniversal, renderingMode: .alwaysOriginal)
            static let grayRatingStar = UIImage(systemName: "star.fill")?.withTintColor(.lightGrayDay, renderingMode: .alwaysOriginal)
            static let goldRatingStar = UIImage(systemName: "star.fill")?.withTintColor(.yellowUniversal, renderingMode: .alwaysOriginal)
            static let putInBasket = UIImage(named: "emptyCart")?.withTintColor(.blackDay, renderingMode: .alwaysOriginal)
            static let removeFromBasket = UIImage(named: "removeBasket")?.withTintColor(.blackDay, renderingMode: .alwaysOriginal)
        }
    }
    
    enum Network {
            enum MockAPI {
                static let defaultStringURL = "https://64c516a6c853c26efada7a11.mockapi.io"
                
                enum Paths {
                    static let currencies = "/api/v1/currencies"
                    static let nftCollection = "/api/v1/collections"
                    static let nftCard = "/api/v1/nft"
                    static let orders = "/api/v1/orders"
                    static let orderPayment = "/api/v1/orders/1/payment"
                    static let profile = "/api/v1/profile"
                    static let users = "/api/v1/users"
                }
            }
            static let metricaAPIKey = "de532bb8-8a8d-4118-94ad-dbde6f544bf6"
        }
}
