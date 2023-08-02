import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
    }

    func setTabBar() {
        let appearance = UITabBarAppearance()

        tabBar.standardAppearance = appearance
        tabBar.backgroundColor = .whiteDay
        
        // Initialize dependencies:
        let catalogViewModel = CatalogViewModel()
        
        // Initizialize ViewControllers:
        let catalogViewController = CatalogViewController(viewModel: catalogViewModel)

        let profileViewController = CustomNavigationController(rootViewController: UIViewController())
        let catalogNavigationController = CustomNavigationController(rootViewController: catalogViewController)
        let cartViewController = CustomNavigationController(rootViewController: UIViewController())
        let statisticViewController = CustomNavigationController(rootViewController: UIViewController())

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
}
