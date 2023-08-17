import UIKit

final class CustomNavigationController: UINavigationController {
  
    // MARK: - Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

// MARK: - Setup Views:
extension CustomNavigationController {
    private func setupViews() {
        navigationBar.backgroundColor = .whiteDay
        navigationBar.tintColor = .blackDay
        
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
    }
}
