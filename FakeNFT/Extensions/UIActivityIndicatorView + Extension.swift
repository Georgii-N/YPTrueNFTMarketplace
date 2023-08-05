import UIKit

extension UIActivityIndicatorView {
    func blockUI(view: UIView) {
        view.isUserInteractionEnabled = false
        isHidden = false
        startAnimating()
    }
    
    func unblockUI(view: UIView) {
        view.isUserInteractionEnabled = false
        isHidden = true
        stopAnimating()
    }
}
