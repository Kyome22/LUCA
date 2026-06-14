import os

public struct AppStateClient: DependencyClient {
    private let lock: OSAllocatedUnfairLock<AppState>

    private init(lock: OSAllocatedUnfairLock<AppState>) {
        self.lock = lock
    }

    public func withLock<R: Sendable>(_ body: @Sendable (inout AppState) throws -> R) rethrows -> R {
        try lock.withLock(body)
    }

    public static let liveValue = Self(lock: .init(initialState: .init()))

    public static let testValue = Self(lock: .init(initialState: .init()))

    public static func testDependency(_ appState: OSAllocatedUnfairLock<AppState>) -> Self {
        Self(lock: appState)
    }
}
