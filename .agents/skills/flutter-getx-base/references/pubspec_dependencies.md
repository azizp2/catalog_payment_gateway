# Recommended Pubspec Dependencies

Standard `pubspec.yaml` specification for the user's base Flutter project.

```yaml
name: my_app
description: "A new Flutter project based on GetX and Freezed architecture."
publish_to: "none"
version: 1.0.0+1

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter

  # State Management, Navigation & DI
  get: ^4.6.6

  # Data Modeling & Immutability
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0

  # Networking
  dio: ^5.7.0

  # Utilities
  intl: ^0.19.0
  shared_preferences: ^2.3.2

  # Icons & Visuals
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0

  # Code Generation
  build_runner: ^2.4.13
  freezed: ^2.5.7 # or ^4.0.0-dev
  json_serializable: ^6.8.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/icons/
```

---

## Analysis Options (`analysis_options.yaml`)

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    prefer_const_constructors: true
    prefer_const_literals_to_create_immutables: true
    unnecessary_this: true
    avoid_print: true
```
