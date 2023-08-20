import UIKit

enum TypeOfButton {
    case white
    case black
}

final class BaseButton: UIButton {
    
    // MARK: - Constants and Variables:
    private let labelText: String?
    private let typeOfButton: TypeOfButton?
    private var heightOfButton: CGFloat?
    
    // MARK: - Lifecycle:
    init(with type: TypeOfButton, title: String) {
        self.typeOfButton = type
        self.labelText = title
        super.init(frame: .zero)
        setupConstraints()
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
    private func setupColor() {
        if typeOfButton == .white {
            layer.borderColor = UIColor.blackDay.cgColor
        }
    }
}

// MARK: - Setup Views:
extension BaseButton {
    private func setupUI() {
        switch typeOfButton {
        case .black:
            backgroundColor = .blackDay
            setTitle(labelText, for: .normal)
            setTitleColor(.whiteDay, for: .normal)
            layer.cornerRadius = 16
            titleLabel?.textAlignment = .center
            titleLabel?.font = .captionMediumBold
            self.heightOfButton = 60
        case .white:
            backgroundColor = .whiteDay
            setTitle(labelText, for: .normal)
            setTitleColor(.blackDay, for: .normal)
            layer.cornerRadius = 16
            layer.borderWidth = 1.0
            titleLabel?.textAlignment = .center
            titleLabel?.font = .captionSmallRegular
            self.heightOfButton = 40
            setupColor()
        case .none:
            break
        }
    }
}

// MARK: - Setup Constraints:
extension BaseButton {
    private func setupConstraints() {
        guard let heightOfButton = heightOfButton else { return }
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: heightOfButton)
        ])
    }
}
