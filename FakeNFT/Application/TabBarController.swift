import UIKit
import StoreKit

final class TabBarController: UITabBarController {
    
    // MARK: - Private properties:
    var randomBoolWithProbability: Bool {
        let trueProbability = 0.3
        return Double.random(in: 0..<1) < trueProbability
    }
    
    // MARK: - Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        selectedIndex = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if randomBoolWithProbability {
            SKStoreReviewController.requestReview()
        }
        
        checkMetriсaAgreement()
    }
    
    // MARK: - Private func
    private func setTabBar() {
        let appearance = UITabBarAppearance()
        
        tabBar.standardAppearance = appearance
        tabBar.backgroundColor = .white
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            assertionFailure("appDelegate not found")
            return
        }
        
        let dataProvider = appDelegate.dataProvider
        
        // Initialize dependencies:
        let catalogViewModel = CatalogViewModel(dataProvider: dataProvider)
        let statisticViewModel = StatisticViewModel(dataProvider: dataProvider)
        let cartViewModel = CartViewModel(dataProvider: dataProvider)
        
        // Initizialize ViewControllers:
        let catalogViewController = CatalogViewController(viewModel: catalogViewModel)
        
        let profileViewController = CustomNavigationController(rootViewController: UIViewController())
        let catalogNavigationController = CustomNavigationController(rootViewController: catalogViewController)
        let statisticViewController = CustomNavigationController(rootViewController: StatisticViewController(statisticViewModel: statisticViewModel))
        let cartViewController = CustomNavigationController(rootViewController: CartViewControler(cartViewModel: cartViewModel))

        profileViewController.tabBarItem = UITabBarItem(
            title: L10n.Profile.title,
            image: Resources.Images.TabBar.profileImage,
            selectedImage: Resources.Images.TabBar.profileImageSelected)
        catalogViewController.tabBarItem = UITabBarItem(
            title: L10n.Catalog.title,
            image: Resources.Images.TabBar.catalogImage,
            selectedImage: Resources.Images.TabBar.catalogImageSelected)
        cartViewController.tabBarItem = UITabBarItem(
            title: L10n.Basket.title,
            image: Resources.Images.TabBar.cartImage,
            selectedImage: Resources.Images.TabBar.cartImageSelected)
        statisticViewController.tabBarItem = UITabBarItem(
            title: L10n.Statistic.title,
            image: Resources.Images.TabBar.statisticImage,
            selectedImage: Resources.Images.TabBar.statisticImageSelected)

        self.viewControllers = [profileViewController, catalogNavigationController,
                                cartViewController, statisticViewController]
    }
    
    // MARK: - Private Methods:
    private func checkMetriсaAgreement() {
        if UserDefaultsService.shared.getAgreement() == false {
            UniversalAlertService().showMetricaAlert(controller: self)
        }
    }
}
