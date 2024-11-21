import UIKit

class EventDetailsViewController: GEViewController {
    
    private let viewModel: EventDetailsViewModelProtocol
    private let eventDetailsView = EventDetailsView()
    
    // MARK: - Initialization
    init(viewModel: EventDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = eventDetailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.eventType
        configureView()
    }
    
    // MARK: - Other functions
    private func configureView() {
        eventDetailsView.configure(with: viewModel)
    }
}
