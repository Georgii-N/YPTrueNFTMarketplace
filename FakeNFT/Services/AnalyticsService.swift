import Foundation
import YandexMobileMetrica

enum Screens: String {
        case CatalogMain = "CatalogMain"
        case CartMain = "CartMain"
    
        case ProfileMain = "ProfileMain"
    
        case StatisticMain = "StatisticMain"
        case StatisticProfile = "StatisticProfile"
        case StatisticСollectionNFT = "StatisticСollectionNFT"
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
