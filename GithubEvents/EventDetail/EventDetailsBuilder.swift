import UIKit

class EventDetailsBuilder {
    static func build(with event: Event) -> EventDetailsViewController {
        let eventDetailsViewModel = EventDetailsViewModel(event: event)
        let eventDetailsViewController = EventDetailsViewController(viewModel: eventDetailsViewModel)
        return eventDetailsViewController
    }
}
