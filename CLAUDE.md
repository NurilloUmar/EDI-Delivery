# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run

Open `EDI Delivery.xcodeproj` in Xcode and build/run from there. Dependencies are managed via **Swift Package Manager** (no Podfile). The staging backend URL is `https://staging-edi.hippo.uz` (defined in `Data/Networking/Base/Domain.swift`).

There are **no test targets** and **no linting configuration** (.swiftlint.yml / .swiftformat) in the project.

## Architecture

The app uses **MVVM + Coordinator** with UIKit as the root layer and SwiftUI for screen content.

### Layer Structure

- **`App/`** — `AppDelegate` bootstraps `DIContainer.shared` and `AppCoordinator`, then starts `NetworkMonitor`. `DIContainer` uses **Swinject** (`Assembler` + `Assembly` modules). `NetworkAssembly` registers services as `.container`-scoped singletons.
- **`Data/Networking/`** — Built on **Alamofire**. Routers are enums conforming to `BaseURLRequestConvertible`, which handles URL construction, HTTP method, parameters (GET → URLEncoding, other → JSONEncoding), and default auth headers. `BaseService.request()` sends the request and pipes the `DataResponse` into `AnalysisResponseMonitor`.
- **`Presentation/`** — UIKit `ViewController` + Coordinator shell, with SwiftUI views embedded inside.

### UIKit + SwiftUI Bridging

Every screen's `ViewController` calls `addSwiftUI(view: SomeView(viewModel: viewModel))` in `viewDidLoad`. This mounts a `UIHostingController` filling the full bounds. The SwiftUI view uses `@ObservedObject` on the ViewModel and calls `viewModel.handleEvent(eventType:)` for actions. ViewControllers may also use Combine `.sink()` for reactive nav bar updates (e.g., reflecting item count in the navigation title), but the primary SwiftUI ↔ ViewModel binding is through `@ObservedObject` alone — no sink wiring inside the SwiftUI body.

### Per-screen File Set

Each screen has exactly five files:
- `{Name}ViewController.swift` — UIKit shell, embeds SwiftUI view, adds nav bar items
- `{Name}ViewModel.swift` — `ObservableObject`, `@Published var item: {Name}UIState`, `@MainActor func handleEvent(eventType:)`
- `{Name}UIState.swift` — plain struct of all view-bindable state; mutated only in the ViewModel
- `{Name}Coordinator.swift` — implements a typed `{Name}Navigation` protocol, received by the ViewModel
- `components/{Name}View.swift` — SwiftUI body, observes ViewModel

## Navigation

`AppCoordinator` is the root. It reads `Cache.share.getUserToken()` to decide the initial route: `LoginCoordinator` → `MainCoordinator`. All navigation decisions after launch go through `AuthSession.delegate` (type `AuthSessionDelegate`), which `AppCoordinator` implements. On a 401, `AnalysisResponseMonitor` clears the token and calls `AuthSession.delegate?.routeToAuth()` from the network layer.

`AuthSessionDelegate` exposes two hooks, both implemented by `AppCoordinator`: `routeToAuth()` (force logout) and `reloadRoot()` (rebuild the root controller in place — used after a language change so every UIKit title and SwiftUI string re-evaluates).

Each Coordinator receives a typed `Navigation` protocol (e.g. `LoginNavigation`, `MainNavigation`) injected into its ViewModel, keeping ViewModels decoupled from concrete Coordinators.

The `Coordinator` protocol extension provides: `pushTo(coordinator:)`, `presentTo(coordinator:)`, `pushController(_:)`, `present(controller:)`, `presentShareScreen(with:)`, `presentSettings()`, `presentURL(path:)`, `isNavStackContainsController(ofType:)`, and `setRootControllerToWindow(_:)`.

`MainCoordinator` routes to six feature flows: Orders, Products, Branches, Baskets, Documents, Profile.

## Request/Response Flow

1. Coordinator resolves a service from `DIContainer.shared.resolver.get()`
2. ViewModel calls a service method which calls `BaseService.request(_:completion:)`
3. `AnalysisResponseMonitor` checks status: `401` forces logout **only if a token is stored** (a 401 during login is treated as "wrong credentials" and falls through to normal error handling); `2xx` decodes; any other status (incl. `502`) parses `json["message"]`/`json["error"]` and throws. **All failures funnel into one catch** that calls `Loader.stop()`, shows the error `Alert` with the server message, and calls the completion — error alerts are guaranteed centrally, so ViewModels must NOT show their own `.error` alerts in failure branches (state cleanup only)
4. Decoding is handled by `NetworkDecoder<T>`; empty-body 2xx responses are handled by casting to `EmptyResponse`
5. All callbacks dispatch to `DispatchQueue.main`

`NetworkError` cases: `.standard`, `.technical`, `.unexpected(description:)`, `.unableToConnect`, `.unauthorized`. User-facing error strings (e.g. `.unableToConnect` → `L(.noInternet)`, and the status-code messages in `AnalysisResponseMonitor`) go through the localization system (see **Localization**), so they honor the selected language.

The default `Authorization` header value is pulled from `Cache.share.getUserToken()` on every request. The `Accept-Language` header value is `LocalizationManager.shared.language.rawValue` (the currently selected app language, not a hardcoded `"uz"`).

## State Patterns

- `UIState<T>` — generic enum (`isLoading` / `success(T)` / `error(ErrorData)`) for async results
- `{Name}UIState` — plain struct holding all bindable state for a screen
- `PaginationHandler` — `@MainActor` enum with two static methods: `prepare(state:reset:)` sets loading flags and resets on pull-to-refresh; `apply(result:state:reset:extract:)` appends/replaces items, updates `hasMore` and `skip`. Any state struct conforming to `PaginatedItemList` can use it.

## Shared UI Utilities

- `Loader.start()` / `Loader.stop()` — Lottie full-screen loading overlay pinned to the key window. Always call `Loader.stop()` in both success and failure branches of a network call.
- `Alert.showAlert(forState:message:vibrationType:)` — slides a toast banner down from the status bar. States: `.success`, `.error`, `.warning`, `.progress`, `.unknown`. `.error` alerts for failed requests come **centrally from `AnalysisResponseMonitor`** (never duplicate them in ViewModels); ViewModels only show `.success`/`.warning` domain alerts (validation, confirmations).

### Common UI Components (`Presentation/CommonUI/`)

Reuse these before building new UI primitives:
- `AppSearchBar` / `SearchBar` — search input with standard styling
- `AppCard` — card container with standard shadow and radius
- `AppSegmentControl` — segmented tab control
- `AppStatusBadge` — colored dot + label badge
- `AppFilterChip` — pill-shaped filter toggle
- `AppEmptyState` — empty state illustration + message
- `SearchEmptyView` — empty state specific to search results
- `CustomTextFieldView` — text field with label and validation state
- `PrimaryBtn` — primary CTA button

## Base Classes

- `BaseViewController` — sets `navigationItem.backButtonTitle = ""`, calls `setupSubviews()` on `viewDidLoad`, which calls `embedSubviews()` then `setSubviewsConstraints()`. Override these two for UIKit layout.
- `BaseView` — same `setupView` → `embedSubviews` + `setSubviewsConstraints` lifecycle for `UIView` subclasses.

`ViewController+Ext.swift` also provides `setNavBarAppearance(with:backgroundColor:shouldApply:)` and device-detection properties (`hasNotch`, `hasDynamicIsland`, `safeAreaInsets`).

## Design System

- **Colors** — `AppColor` (SwiftUI `Color` tokens) and `UIColor` extensions (`.appBrand`, `.appSuccess`, `.appWarning`, `.appDanger`, `.appInfo`, `.appNeutral`). Never use raw hex; always use named tokens. Semantic groups: brand, background/surface, success, warning, danger, document-type (`docInvoice`, `docContract`, `docAct`, `docOther`).
- **Typography** — `AppFont` tokens: `largeTitle`, `title`, `title2`, `headline`, `body`, `bodyMedium`, `bodySemibold`, `callout`, `calloutMedium`, `calloutSemibold`, `caption`, `captionMedium`, `captionSmall`, `captionSmallMedium`, `numericLarge`, `numericMedium`.
- **Spacing/sizing** — `AppMetric` constants: spacing (`spacingXS`=4, `spacingSM`=8, `spacingMD`=12, `spacingLG`=16, `spacingXL`=24, `spacingXXL`=32), corner radius (`radiusSM`=10, `radiusMD`=14, `radiusLG`=18, `radiusPill`=22), card (`cardPadding`=16, `cardRadius`=18), controls (`controlHeight`=48).
- **Density-independent sizing** — `.dp` extension on `Int`/`CGFloat`/`Double` scales relative to a 375-pt base width (or 667-pt height for non-tall screens).

## Cache

`Cache.share` (UserDefaults-backed singleton) stores the bearer token (`getUserToken()` / `saveUserToken(_:)` / `deleteUserToken()`) and the `UserData` profile struct (`getUser()` / `saveUser(_:)` / `deleteUser()`). The token is saved as `"Bearer <raw_token>"`.

## Localization

`Localization.swift` holds a hand-rolled trilingual system — **uz / ru / en**, default fallback `uz`. There are **no `.strings` files**; every translation lives inline in Swift.

- `LKey` is an enum of every user-facing string. Each case returns its three translations from the `translations: (uz, ru, en)` computed property. **To add a string: add a case to `LKey` and its translation tuple.**
- Look strings up with the free function `L(.someKey)` (used ~157 places across `Presentation/` and in the network layer). For strings that embed a runtime value, use the `Loc` enum helpers (`Loc.quantity(_:)`, `Loc.greeting(_:)`) instead of string-concatenating.
- `LocalizationManager.shared` (an `ObservableObject`) holds the selected `AppLanguage`, persists it via `Cache.share.saveLanguage(_:)` / `getLanguage()`, and on change calls `AuthSession.delegate?.reloadRoot()` to rebuild the root so all titles re-evaluate. There is **no** `appLanguageDidChange` notification and no `LanguageManager` type — ignore any doc that mentions them.

## DI

Register new services in `NetworkAssembly.assemble(container:)` with `.inObjectScope(.container)`. Resolve with `DIContainer.shared.resolver.get(ServiceType.self)` or the shorthand `resolver.get()` (type inferred from context).

## Notes

There is a second `CLAUDE.md` inside `EDI Delivery/CLAUDE.md` (the Xcode project subfolder). Its content is stale and inaccurate — ignore it; this root-level file is authoritative.

## Dependencies (Swift Package Manager)

- **Alamofire** 5.12.0 — networking
- **Swinject** 2.10.0 — dependency injection
- **SwiftyJSON** 5.0.2 — JSON parsing in `AnalysisResponseMonitor`
- **Lottie** 4.6.0 — animations (`Loader`, empty states)
