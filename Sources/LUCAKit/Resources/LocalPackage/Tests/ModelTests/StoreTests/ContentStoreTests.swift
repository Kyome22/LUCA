import os
import Testing

@testable import DataSource
@testable import Model

struct ContentStoreTests {
    @MainActor @Test
    func send_task() async throws {
        let appState = OSAllocatedUnfairLock<AppState>(initialState: .init(name: "test", version: "0.0.0"))
        let sut = ContentStore(.testDependencies(
            appStateClient: .testDependency(appState),
            userDefaultsClient: testDependency(of: UserDefaultsClient.self) {
                $0.bool = { key in
                    guard key == "isEnabled" else { return false }
                    return true
                }
            }
        ))
        await sut.send(.task("Test"))
        #expect(sut.appName == "test")
        #expect(sut.appVersion == "0.0.0")
        #expect(sut.isEnabled)
    }

    @MainActor @Test
    func send_plusButtonTapped() async throws {
        let appState = OSAllocatedUnfairLock<AppState>(initialState: .init())
        let sut = ContentStore(.testDependencies(appStateClient: .testDependency(appState)))
        await sut.send(.task("Test"))
        await sut.send(.plusButtonTapped)
        await waitUntil { sut.count == 1 }
        #expect(sut.count == 1)
        await sut.send(.onDisappear)
    }

    @MainActor @Test
    func observes_count_stream() async throws {
        let appState = OSAllocatedUnfairLock<AppState>(initialState: .init())
        let sut = ContentStore(.testDependencies(appStateClient: .testDependency(appState)))
        await sut.send(.task("Test"))
        appState.withLock { $0.count.send(5) }
        await waitUntil { sut.count == 5 }
        #expect(sut.count == 5)
        await sut.send(.onDisappear)
    }

    @MainActor @Test
    func send_isEnabledToggleSwitched() async throws {
        let results = OSAllocatedUnfairLock<[Bool]>(initialState: [])
        let sut = ContentStore(.testDependencies(
            userDefaultsClient: testDependency(of: UserDefaultsClient.self) {
                $0.setBool = { value, key in
                    guard key == "isEnabled" else { return }
                    results.withLock { $0.append(value) }
                }
            },
        ))
        await sut.send(.isEnabledToggleSwitched(true))
        #expect(sut.isEnabled)
        #expect(results.withLock(\.self) == [true])
    }
}
