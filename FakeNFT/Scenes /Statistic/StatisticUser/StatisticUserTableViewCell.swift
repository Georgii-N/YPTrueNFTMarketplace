import UIKit

final class StatisticUserTableViewCell: UITableViewCell {
    
    // MARK: - UI
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .blackDay
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - ReuseIdentifying
extension StatisticUserTableViewCell: ReuseIdentifying {
    static let defaultReuseIdentifier = "statisticUserTableViewCell"
}

// MARK: - Private Functions
extension StatisticUserTableViewCell {
    private func setupViews() {
        contentView.setupView(titleLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
}
