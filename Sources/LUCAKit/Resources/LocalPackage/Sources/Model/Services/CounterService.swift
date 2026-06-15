import DataSource

struct CounterService {
    private let appStateClient: AppStateClient

    init(_ appDependencies: AppDependencies) {
        self.appStateClient = appDependencies.appStateClient
    }

    func increment() {
        appStateClient.send(\.count, default: 0) { $0 += 1 }
    }

    func reset() {
        appStateClient.send(\.count, 0)
    }
}
