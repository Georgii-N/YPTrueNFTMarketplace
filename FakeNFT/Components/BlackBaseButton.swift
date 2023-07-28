import UIKit

final class BaseBlackButton: UIButton {
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
        self.backgroundColor = .blackDay
        self.setTitle(labelText, for: .normal)
        self.setTitleColor(.whiteDay, for: .normal)
        self.layer.cornerRadius = 16
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)

        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
