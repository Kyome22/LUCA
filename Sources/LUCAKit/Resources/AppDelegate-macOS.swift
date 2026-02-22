import AppKit
import DataSource

public final class AppDelegate: NSObject, NSApplicationDelegate {
    public let appDependencies = AppDependencies.shared

    public func applicationDidFinishLaunching(_ notification: Notification) {
        appDependencies.appStateClient.withLock {
            $0.name = Bundle.main.bundleName
            $0.version = Bundle.main.bundleVersion
        }

        let logService = LogService(appDependencies)
        logService.bootstrap()
        logService.notice(.launchApp)
    }
}
