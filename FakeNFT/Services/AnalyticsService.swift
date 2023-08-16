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

enum Items: String {
    case screen = "Screen"
    case collectionCell = "CollectionCell"
    case buttonSorting = "ButtonSorting"
    case buttonSortingByName = "ButtonSortingByName"
    case buttonSortingByRating = "ButtonSortingByRating"
    case buttonSortingByTitle = "buttonSortingByTitle"
    case buttonSortingByNumber = "buttonSortingByNumber"
    case buttonSortingByPrice = "buttonSortingByPrice"
    case buttonGoToUserSite = "ButtonGoToUserSite"
    case buttonGoToUserCollection = "ButtonGoToUserCollection"
    case buttonAddToCard = "ButtonAddToCard"
    case buttonLike = "ButtonLike"
    case pullToRefresh = "BullToRefresh"
    case swipeNFTCard = "SwipeNFTCard"
    case scaleNFTCard = "ScaleNFTCard"
}

enum Events: String {
    case click = "Click"
    case open = "Open"
    case close = "Close"
    case pull = "Pull"
}

final class AnalyticsService {
    
    static let instance = AnalyticsService()

    private init() {}
    
    func sentEvent(screen: Screens, item: Items, event: Events) {
        var parameters: [AnyHashable: Any] = [:]
        parameters = [item.rawValue: event.rawValue]
        
        YMMYandexMetrica.reportEvent(screen.rawValue, parameters: parameters) { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        }
    }
}
