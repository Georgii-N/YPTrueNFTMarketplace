import Foundation
import YandexMobileMetrica

enum Screens: String {
    // Catalog screens:
    case catalogMain = "CatalogMain"
    case catalogCollection = "CatalogCollection"
    case catalogAboutAuthor = "CatalogAboutAuthor"
    case nftCard = "CatalogNFTCard"
    case catalogAboutAuthorFromNFTCard = "CatalogAboutAuthorFromNFTCard"
    case aboutCurrency = "CatalogAboutCurrency"
    case browsingNFTCard = "CatalogBrowsingNFTCard"
    
    // Cart screens:
    case cartMain = "CartMain"
    
    // Pforile screens:
    case profileMain = "ProfileMain"
    
    // Statistic screens:
    case statisticMain = "StatisticMain"
    case statisticProfile = "StatisticProfile"
    case statisticСollectionNFT = "StatisticСollectionNFT"
}

enum Items {
    case screen
    case buttonSorting
    case buttonSortingByName
    case buttonSortingByRating
    case buttonGoToUserSite
    case buttonGoToUserCollection
    case buttonAddToCard
    case buttonLike
    case pullToRefresh
    case swipeNFTCard
    case scaleNFTCard
}

enum Events {
    case click
    case open
    case close
}

final class AnalyticsService {
    
    static let instance = AnalyticsService()

    private init() {}
    
    func sentEvent(screen: Screens, item: Items, event: Events) {
        var parameters: [AnyHashable: Any] = [:]
        parameters = [item: event]
        
        YMMYandexMetrica.reportEvent(screen.rawValue, parameters: parameters) { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        }
    }
}
