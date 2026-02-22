import UIKit
import DataSource

public final class AppDelegate: NSObject, UIApplicationDelegate {
    public let appDependencies = AppDependencies.shared

    public func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        appDependencies.appStateClient.withLock {
            $0.name = Bundle.main.bundleName
            $0.version = Bundle.main.bundleVersion
        }

        let logService = LogService(appDependencies)
        logService.bootstrap()
        logService.notice(.launchApp)

        return true
    }
}
