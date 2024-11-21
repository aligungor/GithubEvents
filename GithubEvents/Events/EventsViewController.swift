import UIKit
import Combine

class EventsViewController: GEViewController {
    private let viewModel: EventsViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    private let eventsView = EventsView()

    private var cellViewModels: [EventCellViewModel] = []
    
    // MARK: - Initialization
    init(viewModel: EventsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = "Events"
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = eventsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
        viewModel.fetchEvents()
        viewModel.startAutoRefresh()
        configureNavigationBar()
    }
    
    // MARK: - Other functions
    private func configureNavigationBar() {
        let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(openEventFilter))
        navigationItem.rightBarButtonItem = filterButton
    }
    
    @objc private func openEventFilter() {
        viewModel.routeToFilter()
    }

    private func setupTableView() {
        eventsView.tableView.register(EventTableViewCell.self, forCellReuseIdentifier: EventTableViewCell.identifier)
        eventsView.tableView.dataSource = self
        eventsView.tableView.delegate = self
    }

    private func bindViewModel() {
        viewModel
            .eventsSubject
            .sink { [weak self] cellViewModels in
                self?.cellViewModels = cellViewModels
                self?.eventsView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension EventsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.identifier, for: indexPath) as? EventTableViewCell else {
            fatalError("Unable to dequeue EventTableViewCell")
        }
        
        let viewModel = cellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension EventsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedViewModel = cellViewModels[indexPath.row]
        viewModel.routeToEventDetail(with: selectedViewModel)
    }
}
