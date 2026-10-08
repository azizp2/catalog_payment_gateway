---
name: flutter-getx-base
description: >-
  Standard Flutter project blueprint based on GetX (Fuller Get) state management,
  Freezed v4+ data models, feature-first Clean Architecture, and reusable common core modules.
  Activate this skill whenever the user asks to create a new Flutter project, scaffold a feature,
  implement GetX controllers/bindings, write Freezed models, configure API clients, or structure
  a Dart/Flutter codebase following the user's base project conventions.
---

# Base Flutter Project Architecture (GetX + Freezed + Common)

This skill documents the standard blueprint, conventions, and patterns for Flutter projects created by the user. When starting or maintaining Flutter applications, **always adopt this structure by default** without requiring the user to re-explain their architectural preferences.

---

## 1. Architectural Philosophy

1. **Feature-First Organization**: Code is grouped by business domain / feature rather than technical layer (`lib/features/<feature>/...`).
2. **Clean Separation of Concerns**:
   - **Page / UI**: Pure presentation via `GetView<XController>`.
   - **Controller**: Business and presentation logic via `GetxController`.
   - **Repository**: Data abstraction interface and implementation.
   - **DataSource**: Direct remote/local communication (HTTP/Dio, storage).
   - **Model**: Immutable data representations with Freezed (`@freezed`).
   - **Binding**: Dependency injection via `Bindings` and `Get.lazyPut`.
3. **Core / Common Foundation**: Reusable widgets, error handling, network clients, and utilities reside in `lib/core/`.
4. **App Root Configuration**: Routes, theme, and global bindings reside in `lib/app/`.
5. **Customer-Facing UX Standards**: Never expose internal GUIDs, raw exceptions, or server jargon in the presentation layer. Use clear Indonesian e-commerce labels.

---

## 2. Standard Directory Layout

```text
lib/
├── app/
│   ├── config/          # Environment configuration (app_config.dart)
│   ├── routes/          # Named routing (app_routes.dart, app_pages.dart)
│   ├── theme/           # Design system (app_colors.dart, app_theme.dart)
│   ├── app.dart         # GetMaterialApp root
│   └── app_binding.dart # Root global dependencies (ApiClient, etc.)
│
├── core/
│   ├── exceptions/      # Custom domain exceptions (app_exception.dart, api_exception.dart)
│   ├── models/          # Shared DTOs (api_error.dart, base_response.dart)
│   ├── network/         # HTTP client & endpoints (api_client.dart, api_endpoints.dart)
│   ├── utils/           # Utilities (currency_formatter.dart, snackbar_helper.dart)
│   └── widgets/         # Shared UI (app_button.dart, app_input.dart, empty_state.dart)
│
├── features/
│   └── <feature_name>/
│       ├── bindings/    # Feature GetX bindings (<feature>_binding.dart)
│       ├── controllers/ # GetX controllers (<feature>_controller.dart)
│       ├── data_sources/# Remote / local data sources (<feature>_remote_data_source.dart)
│       ├── models/      # Freezed models and DTOs (*.dart, *.freezed.dart, *.g.dart)
│       ├── pages/       # Feature views (<feature>_page.dart)
│       ├── repositories/# Repository interface & impl (<feature>_repository.dart)
│       └── widgets/     # Feature-scoped UI widgets
│
└── main.dart            # Entrypoint (runApp with GetMaterialApp)
```

---

## 3. Core Framework Rules & Conventions

### A. Freezed v4+ Models
* Use **`abstract class`** declaration syntax:
  ```dart
  import 'package:freezed_annotation/freezed_annotation.dart';

  part 'my_model.freezed.dart';
  part 'my_model.g.dart';

  @freezed
  abstract class MyModel with _$MyModel {
    const MyModel._(); // Required for custom getters/methods

    const factory MyModel({
      @Default('') String id,
      @Default('') String name,
      @Default(0.0) double price,
    }) = _MyModel;

    factory MyModel.fromJson(Map<String, dynamic> json) => _$MyModelFromJson(json);

    // Custom getters
    bool get isValid => name.isNotEmpty;
  }
  ```
* Run code generation using: `dart run build_runner build --delete-conflicting-outputs`.

### B. GetX Controllers & Bindings
* Controllers extend `GetxController`:
  ```dart
  class ExampleController extends GetxController {
    final ExampleRepository repository;
    ExampleController({required this.repository});

    final RxBool isLoading = false.obs;
    final RxList<ExampleModel> items = <ExampleModel>[].obs;

    @override
    void onInit() {
      super.onInit();
      loadItems();
    }
    ...
  }
  ```
* Bindings extend `Bindings`:
  ```dart
  class ExampleBinding extends Bindings {
    @override
    void dependencies() {
      Get.lazyPut<ExampleRemoteDataSource>(() => ExampleRemoteDataSourceImpl(apiClient: Get.find()));
      Get.lazyPut<ExampleRepository>(() => ExampleRepositoryImpl(remoteDataSource: Get.find()));
      Get.lazyPut<ExampleController>(() => ExampleController(repository: Get.find()));
    }
  }
  ```

### C. Pages & UI
* Pages extend `GetView<Controller>`:
  ```dart
  class ExamplePage extends GetView<ExampleController> {
    const ExamplePage({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Judul Halaman')),
        body: Obx(() {
          if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
          return ListView.builder(...);
        }),
      );
    }
  }
  ```

### D. Routing
* Define route names in `AppRoutes`:
  ```dart
  abstract class AppRoutes {
    static const example = '/example';
  }
  ```
* Register routes in `AppPages`:
  ```dart
  GetPage(
    name: AppRoutes.example,
    page: () => const ExamplePage(),
    binding: ExampleBinding(),
  ),
  ```

---

## 4. Sub-Documentation References

For in-depth guides and copy-paste templates, read:
- [Complete Project Structure](references/project_structure.md)
- [Feature Pattern Blueprint](references/feature_pattern.md)
- [Freezed Models Guide](references/freezed_models.md)
- [Core & Common Modules](references/core_common.md)
- [Recommended Pubspec Dependencies](references/pubspec_dependencies.md)

---

## 5. Feature Scaffolding Helper

To quickly scaffold a complete new feature with all directories and boilerplate files, execute:
```bash
bash ~/.gemini/config/skills/flutter-getx-base/scripts/scaffold_feature.sh <feature_name> <ProjectRootPath>
```
