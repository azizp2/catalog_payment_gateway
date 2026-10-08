# Feature Pattern Blueprint

Every feature module in the base project must follow this exact contract to ensure predictability and maintainability across the codebase.

---

## 1. Remote Data Source (`data_sources/<feature>_remote_data_source.dart`)

```dart
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/item_model.dart';

abstract class ItemRemoteDataSource {
  Future<List<ItemModel>> getItems();
  Future<ItemModel> getItemById(String id);
}

class ItemRemoteDataSourceImpl implements ItemRemoteDataSource {
  final ApiClient apiClient;

  ItemRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ItemModel>> getItems() async {
    final response = await apiClient.get(ApiEndpoints.items);
    final list = response.data as List;
    return list.map((e) => ItemModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<ItemModel> getItemById(String id) async {
    final response = await apiClient.get('${ApiEndpoints.items}/$id');
    return ItemModel.fromJson(response.data as Map<String, dynamic>);
  }
}
```

---

## 2. Repository (`repositories/<feature>_repository.dart`)

```dart
import '../data_sources/item_remote_data_source.dart';
import '../models/item_model.dart';

abstract class ItemRepository {
  Future<List<ItemModel>> getItems();
  Future<ItemModel> getItemById(String id);
}

class ItemRepositoryImpl implements ItemRepository {
  final ItemRemoteDataSource remoteDataSource;

  ItemRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ItemModel>> getItems() => remoteDataSource.getItems();

  @override
  Future<ItemModel> getItemById(String id) => remoteDataSource.getItemById(id);
}
```

---

## 3. Controller (`controllers/<feature>_controller.dart`)

```dart
import 'package:get/get.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../models/item_model.dart';
import '../repositories/item_repository.dart';

class ItemController extends GetxController {
  final ItemRepository repository;

  ItemController({required this.repository});

  final RxList<ItemModel> items = <ItemModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }

  Future<void> fetchItems() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final result = await repository.getItems();
      items.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
      SnackbarHelper.showError(
        title: 'Gagal Memuat Data',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
```

---

## 4. Binding (`bindings/<feature>_binding.dart`)

```dart
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../controllers/item_controller.dart';
import '../data_sources/item_remote_data_source.dart';
import '../repositories/item_repository.dart';

class ItemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ItemRemoteDataSource>(
      () => ItemRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
    );
    Get.lazyPut<ItemRepository>(
      () => ItemRepositoryImpl(remoteDataSource: Get.find<ItemRemoteDataSource>()),
    );
    Get.lazyPut<ItemController>(
      () => ItemController(repository: Get.find<ItemRepository>()),
    );
  }
}
```

---

## 5. Page (`pages/<feature>_page.dart`)

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/empty_state.dart';
import '../controllers/item_controller.dart';

class ItemPage extends GetView<ItemController> {
  const ItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Item'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchItems,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value != null) {
          return EmptyState(
            icon: Icons.error_outline,
            title: 'Terjadi Kesalahan',
            description: controller.errorMessage.value!,
            buttonText: 'Coba Lagi',
            onButtonPressed: controller.fetchItems,
          );
        }

        if (controller.items.isEmpty) {
          return EmptyState(
            icon: Icons.inbox_outlined,
            title: 'Belum Ada Data',
            description: 'Item belum tersedia saat ini.',
            buttonText: 'Segarkan',
            onButtonPressed: controller.fetchItems,
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchItems,
          child: ListView.builder(
            itemCount: controller.items.length,
            itemBuilder: (context, index) {
              final item = controller.items[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text(item.formattedPrice),
              );
            },
          ),
        );
      }),
    );
  }
}
```

---

## 6. Route Registration

1. Add entry in `lib/app/routes/app_routes.dart`:
   ```dart
   static const items = '/items';
   ```
2. Add `GetPage` in `lib/app/routes/app_pages.dart`:
   ```dart
   GetPage(
     name: AppRoutes.items,
     page: () => const ItemPage(),
     binding: ItemBinding(),
   ),
   ```
