# Detailed Project Structure Guide

This document describes the exact directory hierarchy, responsibilities, and file naming conventions for the user's base Flutter project.

---

## 1. Top-Level Layout

```text
├── android/               # Android native configuration (Gradle, Manifest)
├── linux/                 # Desktop Linux configuration
├── lib/                   # Flutter source code
│   ├── app/               # Application-level orchestration
│   ├── core/              # Shared reusable foundation
│   ├── features/          # Domain-driven feature modules
│   └── main.dart          # App entrypoint
├── test/                  # Unit and widget tests
│   └── unit/              # Feature & controller unit tests
├── pubspec.yaml           # Dependencies and assets
├── analysis_options.yaml  # Linting configurations
└── README.md              # Project documentation
```

---

## 2. Directory Breakdown

### `lib/app/` (Application Orchestration)
Responsible for starting and configuring the app across the entire lifecycle:
- **`config/app_config.dart`**: Stores environment-level values (e.g. `baseUrl`, `appName`, `environment`).
- **`routes/app_routes.dart`**: Defines static string route paths (e.g. `static const catalog = '/catalog';`).
- **`routes/app_pages.dart`**: Contains `List<GetPage>` linking routes, pages, and their bindings.
- **`theme/app_colors.dart`**: Design system palette (Primary, Secondary, Success, Warning, Error, Background, Border).
- **`theme/app_theme.dart`**: Configures `ThemeData.light()` with component themes (AppBar, Card, ElevatedButton, etc.).
- **`app_binding.dart`**: Root `Bindings` loaded at application startup (injects `ApiClient`, global services).
- **`app.dart`**: The root `StatelessWidget` returning `GetMaterialApp(initialRoute: AppRoutes.main, getPages: AppPages.pages, ...)`.

---

### `lib/core/` (Common / Shared Layer)
Code here has **no feature-specific business logic**. It can be imported by any feature:
- **`exceptions/`**:
  - `app_exception.dart`: Base exception class.
  - `api_exception.dart`: HTTP/API error wrapper containing statusCode and user-readable message.
- **`models/`**:
  - `base_response.dart`: Generic response wrapper (`data`, `success`, `message`).
  - `api_error.dart`: Freezed model mapping server error payloads (`code`, `message`, `details`).
- **`network/`**:
  - `api_client.dart`: Dio / HTTP client wrapper with timeouts, headers, logging, and error conversion.
  - `api_endpoints.dart`: Centralized API URL constants.
- **`utils/`**:
  - `currency_formatter.dart`: Formats numbers to IDR (`Rp 150.000`) or standard formats.
  - `snackbar_helper.dart`: GetX snackbar wrapper (`showSuccess`, `showError`, `showInfo`).
- **`widgets/`**:
  - `app_button.dart`: Standard styled button supporting primary, secondary, outlined, and danger variants with loading state.
  - `app_input.dart`: Form text field with label, icon, validation, and helperText.
  - `empty_state.dart`: Clean empty or error state card with icon, title, description, and action button.
  - `app_bottom_navigation.dart`: Standard bottom bar with badges.

---

### `lib/features/<name>/` (Feature Module)
Every feature follows an identical modular structure:
- **`bindings/<feature>_binding.dart`**: Registers dependencies with `Get.lazyPut`.
- **`controllers/<feature>_controller.dart`**: Manages state (`.obs`), handles user actions, calls repository.
- **`data_sources/<feature>_remote_data_source.dart`**: Executes raw HTTP calls via `ApiClient`.
- **`models/<feature>_model.dart`**: Data models generated using Freezed.
- **`pages/<feature>_page.dart`**: Screen UI extending `GetView<FeatureController>`.
- **`repositories/<feature>_repository.dart`**: Abstract interface and concrete implementation.
- **`widgets/`**: Reusable widgets specific only to this feature (e.g., `product_card.dart`).
