import UIKit
import WebKit

class EventDetailsView: UIView {
    
    // MARK: - UI Components
    private let actorLoginLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .lightGray : .gray
        }
        return label
    }()
    
    private let repoURLLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .cyan : .blue
        }
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = 30
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.layer.borderWidth = 1
        webView.layer.borderColor = UIColor.lightGray.cgColor
        webView.layer.cornerRadius = 8
        webView.clipsToBounds = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    // MARK: - Stack Views
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with viewModel: EventDetailsViewModelProtocol) {
        actorLoginLabel.text = viewModel.actorLogin
        repoURLLabel.text = viewModel.repoURL.absoluteString
        avatarImageView.loadImage(from: viewModel.avatarURL, placeholder: UIImage(systemName: "person.crop.circle"))
        loadRepoURL(viewModel.repoURL)
    }
    
    func loadRepoURL(_ url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .black : .white
        }
        
        infoStackView.addArrangedSubview(actorLoginLabel)
        infoStackView.addArrangedSubview(repoURLLabel)
        
        headerStackView.addArrangedSubview(avatarImageView)
        headerStackView.addArrangedSubview(infoStackView)
        
        contentStackView.addArrangedSubview(headerStackView)
        contentStackView.addArrangedSubview(webView)
        
        addSubview(contentStackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            
            webView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
        ])
    }
}
