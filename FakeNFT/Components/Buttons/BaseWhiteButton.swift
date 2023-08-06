import UIKit

final class BaseWhiteButton: UIButton {
    let labelText: String

    init(with title: String) {
        self.labelText = title
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.backgroundColor = .whiteDay
        self.setTitle(labelText, for: .normal)
        self.setTitleColor(.blackDay, for: .normal)

        self.layer.cornerRadius = 16
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.blackDay.cgColor

        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)

        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
