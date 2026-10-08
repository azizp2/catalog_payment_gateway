# Freezed Models Guide (v4+)

The base project uses [Freezed](https://pub.dev/packages/freezed) for all domain entities, requests, and DTOs.

---

## 1. Freezed 4 Syntax Rules

> [!IMPORTANT]
> In `freezed: ^4.0.0-dev.x` and newer, classes **MUST** be declared with `abstract class X with _$X`.
> Declaring `class X with _$X` will produce compiler warnings or build runner errors.

### Standard Model Template

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
abstract class ProductModel with _$ProductModel {
  // 1. Private constructor required for custom getters/methods
  const ProductModel._();

  // 2. Factory constructor with defaults
  const factory ProductModel({
    @Default('') String id,
    @Default('') String name,
    @Default(0.0) double price,
    @Default('IDR') String currency,
    @Default(0) int stock,
    @Default([]) List<String> tags,
  }) = _ProductModel;

  // 3. JSON deserialization
  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  // 4. Custom domain getters & helper methods
  bool get isInStock => stock > 0;
  bool get isLowStock => stock > 0 && stock <= 5;
}
```

---

## 2. Request / DTO Models

For POST/PUT payloads:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_order_request.freezed.dart';
part 'create_order_request.g.dart';

@freezed
abstract class CreateOrderRequest with _$CreateOrderRequest {
  const factory CreateOrderRequest({
    required String customerId,
    required String customerEmail,
    @Default([]) List<CreateOrderItemRequest> items,
  }) = _CreateOrderRequest;

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderRequestFromJson(json);
}
```

---

## 3. Code Generation Workflow

Whenever you create or modify a Freezed file:

1. Ensure the parts are declared:
   ```dart
   part '<filename>.freezed.dart';
   part '<filename>.g.dart'; // Only if fromJson/toJson is used
   ```
2. Run code generation:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
3. To watch for changes continuously during development:
   ```bash
   dart run build_runner watch --delete-conflicting-outputs
   ```

---

## 4. Key Advantages
* **Immutability**: Values cannot be mutated accidentally. Use `model.copyWith(name: 'New Name')`.
* **Value Equality**: `modelA == modelB` compares fields by value, not pointer reference.
* **Safe JSON Parsing**: `@Default(...)` prevents null-pointer runtime crashes if the backend sends missing keys.
