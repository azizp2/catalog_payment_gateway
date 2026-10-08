# Core & Common Modules Guide

The `lib/core/` package provides reusable building blocks across all features.

---

## 1. Network Layer (`lib/core/network/`)

### `ApiClient`
A centralized HTTP wrapper that standardizes timeouts, authorization headers, logging, and exception mapping:

```dart
class ApiClient {
  final Dio dio;

  ApiClient({required String baseUrl})
      : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {'Content-Type': 'application/json'},
          ),
        );

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await dio.get<T>(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> post<T>(String path, {dynamic data}) async {
    try {
      return await dio.post<T>(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ApiException _handleError(DioException e) {
    final message = e.response?.data?['message'] ?? e.message ?? 'Terjadi kesalahan pada server';
    return ApiException(message: message, statusCode: e.response?.statusCode);
  }
}
```

---

## 2. Common Reusable Widgets (`lib/core/widgets/`)

### `AppButton`
Standardized button supporting `primary`, `outlined`, `danger`, and `secondary` variants with loading indicator:

```dart
enum AppButtonVariant { primary, secondary, outlined, danger }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final AppButtonVariant variant;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.variant = AppButtonVariant.primary,
  });
  ...
}
```

### `AppInput`
Clean text input field with top label, prefix icon, helper text, and validation support:

```dart
class AppInput extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final String? helperText;
  final IconData? prefixIcon;
  final Widget? suffix;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  ...
}
```

### `EmptyState`
Uniform empty or error state view:

```dart
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  ...
}
```

---

## 3. Utilities (`lib/core/utils/`)

### `CurrencyFormatter`
Formats double or int amounts to Indonesian Rupiah (`Rp 150.000`):

```dart
class CurrencyFormatter {
  static String format(double amount) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatCurrency.format(amount);
  }
}
```

### `SnackbarHelper`
Convenient GetX snackbar wrapper with distinct styles for success, error, and info:

```dart
class SnackbarHelper {
  static void showSuccess({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.successLight,
      colorText: AppColors.success,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle, color: AppColors.success),
    );
  }

  static void showError({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.errorLight,
      colorText: AppColors.error,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 4),
      icon: const Icon(Icons.error, color: AppColors.error),
    );
  }
}
```
