import UIKit

public protocol EventsRouterProtocol {
    func routeToError(with message: String)
    func routeToEventDetail(with event: Event)
    func routeToFilter(eventSelection: @escaping EventSelectionHandler)
}

public typealias EventSelectionHandler = ([EventType]) -> (Void)

class EventsRouter: EventsRouterProtocol {
    weak var viewController: EventsViewController?
    
    func routeToError(with message: String) {
        guard let viewController = viewController else { return }
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func routeToEventDetail(with event: Event) {
        guard let viewController = viewController else { return }
        let eventDetailsViewController = EventDetailsBuilder.build(with: event)
        viewController.navigationController?.pushViewController(eventDetailsViewController, animated: true)
    }
    
    func routeToFilter(eventSelection: @escaping EventSelectionHandler) {
        let alert = UIAlertController(title: "Filter Options", message: "Choose an Event Type", preferredStyle: .actionSheet)
        let showAllAction = UIAlertAction(
            title: "Show All",
            style: .default,
            handler: { _ in
                eventSelection(EventType.allCases)
            }
        )
        alert.addAction(showAllAction)
        
        EventType.allCases.forEach { eventType in
            let action = UIAlertAction(
                title: eventType.rawValue,
                style: .default,
                handler: { _ in
                    eventSelection([eventType])
                }
            )
            alert.addAction(action)
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController?.present(alert, animated: true, completion: nil)
    }
}
