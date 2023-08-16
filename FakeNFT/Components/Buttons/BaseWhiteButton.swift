import UIKit

final class BaseWhiteButton: UIButton {
    
    // MARK: - Constants and Variables:
    private let labelText: String

    // MARK: - Lifecycle:
    init(with title: String) {
        self.labelText = title
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Methods:
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupColor()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        transform = .identity
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        transform = .identity
    }

    // MARK: - Private Methods:
    private func setupUI() {
        self.backgroundColor = .whiteDay
        self.setTitle(labelText, for: .normal)
        self.setTitleColor(.blackDay, for: .normal)

        self.layer.cornerRadius = 16
        self.layer.borderWidth = 1.0
        setupColor()
        
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = .captionSmallRegular

        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupColor() {
        self.layer.borderColor = UIColor.blackDay.cgColor
    }
}
