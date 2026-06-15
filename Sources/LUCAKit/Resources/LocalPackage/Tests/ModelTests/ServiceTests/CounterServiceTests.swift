import os
import Testing

@testable import DataSource
@testable import Model

struct CounterServiceTests {
    @Test
    func increment_sends_incremented_count() {
        let appState = OSAllocatedUnfairLock<AppState>(initialState: .init())
        let sut = CounterService(.testDependencies(appStateClient: .testDependency(appState)))
        sut.increment()
        sut.increment()
        #expect(appState.withLock(\.count.latestValue) == 2)
    }

    @Test
    func reset_sends_zero() {
        let appState = OSAllocatedUnfairLock<AppState>(initialState: .init())
        let sut = CounterService(.testDependencies(appStateClient: .testDependency(appState)))
        sut.increment()
        sut.reset()
        #expect(appState.withLock(\.count.latestValue) == 0)
    }
}
