import UIKit
import NotificationBannerSwift

extension UIViewController {
    // MARK: - Navigation Controller setup:
    func setupBackButtonItem() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func isNavigationBarClear(_ isTrue: Bool) {
        if isTrue {
            navigationController?.navigationBar.backgroundColor = .clear
            navigationController?.navigationBar.isTranslucent = true
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
        } else {
            navigationController?.navigationBar.backgroundColor = .whiteDay
            navigationController?.navigationBar.isTranslucent = false
        }
    }
    
    func calculateNavigationHeight() -> CGFloat {
        let statusBarHeight: CGFloat
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let statusBarManager = windowScene.statusBarManager {
            statusBarHeight = statusBarManager.statusBarFrame.size.height
        } else {
            statusBarHeight = 0
        }
        
        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? statusBarHeight
        let topOffset = statusBarHeight + navigationBarHeight

        return topOffset
    }
    
    // MARK: - Resume On Main Thread
    func resumeMethodOnMainThread<T>(_ method: @escaping ((T) -> Void), with argument: T) {
        DispatchQueue.main.async {
            method(argument)
        }
    }
    
    // MARK: - ActivityIndicatior and Blocking UI:
    private var activityIndicator: UIActivityIndicatorView? {
        return view.subviews.first { $0 is UIActivityIndicatorView } as? UIActivityIndicatorView
    }
    
    func blockUI() {
        view.isUserInteractionEnabled = false
        showActivityIndicator()
    }
    
    func unblockUI() {
        view.isUserInteractionEnabled = true
        hideActivityIndicator()
    }
    
    private func showActivityIndicator() {
        if activityIndicator == nil {
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.color = .darkGray
            view.setupView(indicator)
            NSLayoutConstraint.activate([
                indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            indicator.startAnimating()
        } else {
            activityIndicator?.startAnimating()
        }
    }
    
    private func hideActivityIndicator() {
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
    }
    
    // MARK: - Notification Banner:
    private static var lastBannerShowTime: Date?
    
    func showNotificationBanner(with text: String) {
        let currentTime = Date()
        if let lastShowTime = UIViewController.lastBannerShowTime,
           currentTime.timeIntervalSince(lastShowTime) < 2 { return }
        
        let image = Resources.Images.NotificationBanner.notificationBannerImage
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image = image
        imageView.tintColor = .whiteUniversal
        
        let banner = NotificationBanner(title: text,
                                        subtitle: L10n.NetworkError.tryLater,
                                        leftView: imageView, style: .info)
        banner.autoDismiss = false
        banner.dismissOnTap = true
        banner.dismissOnSwipeUp = true
        banner.show()
        
        UIViewController.lastBannerShowTime = currentTime
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            banner.dismiss()
        }
    }
}
