import UIKit

extension UIActivityIndicatorView {
    
    func blockUI(view: UIView) {
        view.isUserInteractionEnabled = false
        self.isHidden = false
        self.startAnimating()
        setupIndicator(view: view)
    }
    
    func unblockUI(view: UIView) {
        view.isUserInteractionEnabled = true
        self.isHidden = true
        self.stopAnimating()
        self.removeFromSuperview()
    }
    
    private func setupIndicator(view: UIView) {
        self.style = .large
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
}
