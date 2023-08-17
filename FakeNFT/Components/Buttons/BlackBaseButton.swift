import UIKit

final class BaseBlackButton: UIButton {
    
    // MARK: - Constants and Variables:
    private let labelText: String
    
    // MARK: - Lifecycle:
    init(with title: String) {
        self.labelText = title
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Methods:
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
}

// MARK: - Setup Views:
extension BaseBlackButton {
    private func setupViews() {
        self.backgroundColor = .blackDay
        self.setTitle(labelText, for: .normal)
        self.setTitleColor(.whiteDay, for: .normal)
        self.layer.cornerRadius = 16
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = .captionMediumBold
    }
}

// MARK: - Setup Views:
extension BaseBlackButton {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
