import UIKit

final class BaseButton: UIButton {
    
    // MARK: - Constants and Variables:
    private let labelText: String
    private let color: UIColor
    
    // MARK: - Lifecycle:
    init(with title: String, color: UIColor) {
        self.labelText = title
        self.color = color
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
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
    private func setupColor() {
        if color == .whiteDay {
            layer.borderColor = UIColor.blackDay.cgColor
        }
    }
}

// MARK: - Setup Views:
extension BaseButton {
    private func setupViews() {
        if color == .blackDay {
           backgroundColor = .blackDay
           setTitle(labelText, for: .normal)
           setTitleColor(.whiteDay, for: .normal)
           layer.cornerRadius = 16
           titleLabel?.textAlignment = .center
           titleLabel?.font = .captionMediumBold
        } else if color == .whiteDay {
           backgroundColor = .whiteDay
           setTitle(labelText, for: .normal)
           setTitleColor(.blackDay, for: .normal)
           layer.cornerRadius = 16
           layer.borderWidth = 1.0
           titleLabel?.textAlignment = .center
           titleLabel?.font = .captionSmallRegular
            
            setupColor()
        }
    }
}

// MARK: - Setup Views:
extension BaseButton {
    private func setupConstraints() {
        let height = color == .whiteDay ? 40 : 60
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
