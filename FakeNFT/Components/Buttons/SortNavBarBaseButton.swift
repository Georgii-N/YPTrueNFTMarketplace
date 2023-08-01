import UIKit

final class SortNavBarBaseButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.setImage(Resources.Images.NavBar.sortIcon, for: .normal)
    }
}
