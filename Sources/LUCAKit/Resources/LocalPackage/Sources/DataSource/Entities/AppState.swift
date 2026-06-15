public struct AppState: Sendable {
    public var name: String
    public var version: String
    public var hasAlreadyBootstrap: Bool
    public var count = AsyncStreamBundle<Int>()

    init(
        name: String = "",
        version: String = "",
        hasAlreadyBootstrap: Bool = false
    ) {
        self.name = name
        self.version = version
        self.hasAlreadyBootstrap = hasAlreadyBootstrap
    }
}
