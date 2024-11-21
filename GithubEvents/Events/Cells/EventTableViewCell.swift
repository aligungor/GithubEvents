import UIKit

class EventTableViewCell: UITableViewCell {
    static let identifier = "EventCell"
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let actorLoginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let repoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .blue
        label.numberOfLines = 0
        return label
    }()
    
    private let eventTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(actorLoginLabel)
        contentView.addSubview(repoLabel)
        contentView.addSubview(eventTypeLabel)
        contentView.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),
            
            actorLoginLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            actorLoginLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            actorLoginLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            repoLabel.topAnchor.constraint(equalTo: actorLoginLabel.bottomAnchor, constant: 4),
            repoLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            repoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            eventTypeLabel.topAnchor.constraint(equalTo: repoLabel.bottomAnchor, constant: 4),
            eventTypeLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            eventTypeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            eventTypeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            timeLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 80)
        ])
    }
    
    func configure(with viewModel: EventCellViewModel) {
        actorLoginLabel.text = viewModel.actorLogin
        repoLabel.text = viewModel.repoName
        eventTypeLabel.text = viewModel.eventType
        avatarImageView.loadImage(
            from: viewModel.avatarURL,
            placeholder: UIImage(systemName: "person.crop.circle")
        )
        timeLabel.text = viewModel.relativeTime
    }
}
