import Foundation

enum SortScreen: String {
    case profile
    case catalog
    case cart
    case statistic
}

class UserDefaultsService {
    
    static let shared = UserDefaultsService()
    
    private init() {}
    
    // Metrica Agreement:
    private var isUserAgreeToSentMetrica: Bool {
        get {
            UserDefaults.standard.object(forKey: "metricaAgreement") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "metricaAgreement")
            UserDefaults.standard.synchronize()
        }
    }
    
    func setNewAgreement(isAgree: Bool) {
        isUserAgreeToSentMetrica = isAgree
    }
    
    func getAgreement() -> Bool {
        isUserAgreeToSentMetrica
    }
    
    // Sorting Memory:
    func saveSortingOption(_ option: SortingOption, forScreen screen: SortScreen) {
        UserDefaults.standard.set(option.sortingOptions, forKey: screen.rawValue)
    }
    
    func getSortingOption(for screen: SortScreen) -> SortingOption? {
        if let rawValue = UserDefaults.standard.value(forKey: screen.rawValue) as? String,
           let option = SortingOption(stringValue: rawValue) {
            return option
        }
        return nil
    }
}
