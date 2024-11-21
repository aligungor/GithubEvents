import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let eventsViewController = EventsBuilder.build()
        let navigationController = UINavigationController(
            rootViewController: eventsViewController
        )
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
        return true
    }
}
