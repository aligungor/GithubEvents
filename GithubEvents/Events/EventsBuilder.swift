import Foundation

final class EventsBuilder {
    static func build() -> EventsViewController {
        let router = EventsRouter()
        let viewModel = EventsViewModel(eventsRouter: router)
        let viewController = EventsViewController(viewModel: viewModel)
        router.viewController = viewController
        return viewController
    }
}
