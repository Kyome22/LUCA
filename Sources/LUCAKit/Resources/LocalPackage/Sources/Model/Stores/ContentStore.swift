import DataSource
import Observation
import SwiftUI

@MainActor @Observable
public final class ContentStore: Composable {
    private let appStateClient: AppStateClient
    private let userDefaultsRepository: UserDefaultsRepository
    private let logService: LogService
    private let counterService: CounterService

    public var appName: String
    public var appVersion: String
    public var count: Int
    public var isEnabled: Bool
    public let action: (Action) async -> Void

    @ObservationIgnored private var task: Task<Void, Never>?

    public init(
        _ appDependencies: AppDependencies,
        appName: String = "",
        appVersion: String = "",
        count: Int = .zero,
        isEnabled: Bool = false,
        action: @escaping (Action) async -> Void = { _ in }
    ) {
        self.appStateClient = appDependencies.appStateClient
        self.userDefaultsRepository = .init(appDependencies.userDefaultsClient)
        self.logService = .init(appDependencies)
        self.counterService = .init(appDependencies)
        self.appName = appName
        self.appVersion = appVersion
        self.count = count
        self.isEnabled = isEnabled
        self.action = action
    }

    public func reduce(_ action: Action) async {
        switch action {
        case let .task(screenName):
            logService.notice(.screenView(name: screenName))
            appName = appStateClient.withLock(\.name)
            appVersion = appStateClient.withLock(\.version)
            isEnabled = userDefaultsRepository.isEnabled
            if let latestCount = appStateClient.withLock(\.count.latestValue) {
                count = latestCount
            }
            task?.cancel()
            task = Task { [weak self, appStateClient] in
                let stream = appStateClient.withLock(\.count.stream)
                for await value in stream {
                    self?.count = value
                }
            }

        case .plusButtonTapped:
            counterService.increment()

        case .resetButtonTapped:
            counterService.reset()

        case let .isEnabledToggleSwitched(isEnabled):
            self.isEnabled = isEnabled
            userDefaultsRepository.isEnabled = isEnabled

        case .onDisappear:
            task?.cancel()
            task = nil
        }
    }

    public enum Action: Sendable {
        case task(String)
        case plusButtonTapped
        case resetButtonTapped
        case isEnabledToggleSwitched(Bool)
        case onDisappear
    }
}
