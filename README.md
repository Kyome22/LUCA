# LUCA

This is a tool to construct LUCA for Xcode project.

## What is LUCA?

[LUCA is a modern architecture for SwiftUI development](https://dev.to/kyome22/luca-a-modern-architecture-for-swiftui-development-3g2i).  
It is a practical architecture optimized for the SwiftUI × Observation era.

| L   | Layered                  | Clear 3-layer separation of concerns   |
| :-- | :----------------------- | -------------------------------------- |
| U   | Unidirectional Data Flow | Single-direction data flow             |
| C   | Composable               | Composability and testability like TCA |
| A   | Architecture             | Architecture                           |

**Layers**

```
┌───────────────────┐
│   UserInterface   │  ← UI provision and event handling
├───────────────────┤
│       Model       │  ← Business logic and state management
├───────────────────┤
│    DataSource     │  ← Data access and infrastructure abstraction
└───────────────────┘
```

**File Structure**

```
.
├── LocalPackage
│   ├── Package.swift
│   ├── Sources
│   │   ├── DataSource
│   │   │   ├── Dependencies
│   │   │   │   └── AppStateClient.swift
│   │   │   ├── Entities
│   │   │   │   ├── AppState.swift
│   │   │   │   └── AsyncStreamBundle.swift
│   │   │   ├── Extensions
│   │   │   ├── Repositories
│   │   │   └── DependencyClient.swift
│   │   ├── Model
│   │   │   ├── Extensions
│   │   │   ├── Services
│   │   │   ├── Stores
│   │   │   ├── AppDelegate.swift (optional)
│   │   │   ├── AppDependencies.swift
│   │   │   └── Composable.swift
│   │   └── UserInterface
│   │       ├── Extensions
│   │       ├── Resources
│   │       ├── Scenes
│   │       └── Views
│   └── Tests
│       └── ModelTests
│           ├── ServiceTests
│           ├── StoreTests
│           ├── TestStore.swift
│           └── WaitUntil.swift
├── ProjectName
│   └── ProjectNameApp.swift
└── ProjectName.xcodeproj
```

## Claude Code Skills

[LUCA-Skills](https://github.com/kyome22/LUCA-Skills) provides [Claude Code](https://claude.ai/claude-code) skills for developing apps with LUCA.

| Command       | Description                                                                      |
| :------------ | :------------------------------------------------------------------------------- |
| `/luca-setup` | Guides project scaffolding — installing prerequisites and running the `luca` CLI |
| `/luca-arch`  | Explains the LUCA architecture: layers, components, data flow, and patterns      |
| `/luca-impl`  | Implements features across all three layers following LUCA coding rules          |
| `/luca-test`  | Writes unit tests for Services and Stores using Swift Testing                    |

## Requirements

- Development with Xcode 26.0+
- Compatible with iOS 18.0+ / macOS 15.0+
- Written in Swift 6.2
- Xcode projects are generated with the bundled [XcodeGen](https://github.com/yonaskolb/XcodeGen), so no separate installation is required

## Installation

**Homebrew**

```sh
brew tap kyome22/tap
brew install luca
```

**Swift Package Manager**

```sh
git clone https://github.com/kyome22/LUCA.git
cd LUCA
swift run luca
```

## Usage

```sh
luca --name <name> --organization-id <organization-id> [--platform <platform>] [--path <path>]
```

**Options**

| Short | Long                | Explain                                                         |
| :---- | :------------------ | :-------------------------------------------------------------- |
| `-n`  | `--name`            | Specify the project name.                                       |
| `-o`  | `--organization-id` | Specify the organization identifier (e.g., com.company).        |
|       | `--platform`        | Specify the target platform (`iOS` or `macOS`). Default: `iOS`. |
| `-p`  | `--path`            | Specify the path to the directory to create Xcode project.      |
