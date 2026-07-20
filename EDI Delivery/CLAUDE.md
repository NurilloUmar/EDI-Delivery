# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run

Open `EDI Delivery.xcodeproj` in Xcode and build/run from there. There is no SPM package; dependencies are managed via CocoaPods or a similar tool — check for a `Podfile` if one appears. The staging backend is `https://staging-edi.hippo.uz`.

## Architecture

The app uses **MVVM + Coordinator** with UIKit (no storyboards). The three-layer structure:

- **`App/`** — `AppDelegate` bootstraps `DIContainer` and `AppCoordinator`. `DIContainer` uses **Swinject** (`Assembler` + `Assembly` modules). `NetworkAssembly` registers all services as `.container`-scoped singletons.
- **`Data/Networking/`** — Network layer built on **Alamofire**. Routers (enums conforming to `BaseURLRequestConvertible`) define endpoints. `BaseService` sends requests; `AnalysisResponseMonitor` handles status codes, decodes responses, and drives auth routing on 401.
- **`Presentation/`** — Each screen has a `{Name}ViewController`, `{Name}ViewModel`, `{Name}UIState`, `{Name}Coordinator`, and a `components/{Name}View`. Views hold all UIKit layout; ViewControllers bind to ViewModels using **Combine** (`@Published` + `sink`). Events flow from VC → VM via `handleEvent(eventType:)`.

## Navigation

`AppCoordinator` is the root and implements `AuthSessionDelegate`. It reads `Cache.share.getUserToken()` to decide the initial route: `LoginCoordinator` (auth flow) or `MainCoordinator` (main flow). On 401, `AnalysisResponseMonitor` calls `AuthSession.delegate?.routeToAuth()` from anywhere in the network layer to force logout.

Each `Coordinator` receives a typed `Navigation` protocol it must satisfy, keeping VMs decoupled from concrete coordinators.

## Base Classes

- `BaseViewController` — calls `setupSubviews()` → `embedSubviews()` + `setSubviewsConstraints()` on `viewDidLoad`; re-calls `localize()` on language-change notifications.
- `BaseView` — same lifecycle (`setupView` → `embedSubviews` + `setSubviewsConstraints`) for UIView subclasses.
- `PaginationHandler` — stateless enum with `prepare(state:reset:)` and `apply(result:state:reset:extract:)` that operate on any `PaginatedItemList` state struct.

## State & UI Patterns

- `UIState<T>` — generic enum (`isLoading` / `success(T)` / `error(ErrorData)`) used for async results.
- `{Name}UIState` — plain struct holding all view-bindable state for a screen; mutated only in the ViewModel.
- All ViewModel work is annotated `@MainActor` where UI updates happen.

## Design System

- **Colors** — `AppColor` (SwiftUI `Color`) and its `UIColor` mirror extensions. Use named tokens (`AppColor.brand`, `.success`, etc.), never raw hex.
- **Typography** — `AppFont` (SwiftUI `Font` tokens).
- **Spacing / sizing** — `AppMetric` constants (`spacingLG`, `cardRadius`, etc.).
- **Density-independent sizing** — `.dp` extension on `Int`/`CGFloat`/`Double` scales values relative to a 375-pt base width.

## Localization

All user-facing strings go through `LanguageManager.shared[LocalizedKey]`. Add keys to the `LocalizedKey` enum first, then add translations in `Localizations.dictionary`. The manager supports **uz / ru / en** with Uzbek as the default fallback. Language changes are broadcast via `Notification.Name.appLanguageDidChange`; `BaseViewController` responds automatically.

## DI

Resolve services via `DIContainer.shared.resolver.get(ServiceType.self)` (or the shorthand `resolver.get()`). Register new services in `NetworkAssembly.assemble(container:)` with `.inObjectScope(.container)`.
