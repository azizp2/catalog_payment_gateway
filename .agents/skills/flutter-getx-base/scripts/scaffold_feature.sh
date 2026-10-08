#!/usr/bin/env bash
# scaffold_feature.sh
# Scaffolds a complete feature module following GetX + Freezed + Clean Architecture
#
# Usage:
#   bash scaffold_feature.sh <feature_name> [project_root]
# Example:
#   bash scaffold_feature.sh order .

set -e

FEATURE_NAME="$1"
PROJECT_ROOT="${2:-.}"

if [ -z "$FEATURE_NAME" ]; then
  echo "Usage: $0 <feature_name> [project_root]"
  echo "Example: $0 product /path/to/flutter_project"
  exit 1
fi

# Convert to snake_case and PascalCase
FEATURE_SNAKE=$(echo "$FEATURE_NAME" | sed -r 's/([A-Z])/_\1/g' | tr '[:upper:]' '[:lower:]' | sed 's/^_//')
FEATURE_PASCAL=$(echo "$FEATURE_SNAKE" | sed -r 's/(^|_)([a-z])/\U\2/g')

TARGET_DIR="$PROJECT_ROOT/lib/features/$FEATURE_SNAKE"

echo "Creating feature: $FEATURE_PASCAL ($FEATURE_SNAKE) at $TARGET_DIR..."

mkdir -p "$TARGET_DIR/bindings"
mkdir -p "$TARGET_DIR/controllers"
mkdir -p "$TARGET_DIR/data_sources"
mkdir -p "$TARGET_DIR/models"
mkdir -p "$TARGET_DIR/pages"
mkdir -p "$TARGET_DIR/repositories"
mkdir -p "$TARGET_DIR/widgets"

# 1. Model
cat <<EOF > "$TARGET_DIR/models/${FEATURE_SNAKE}_model.dart"
import 'package:freezed_annotation/freezed_annotation.dart';

part '${FEATURE_SNAKE}_model.freezed.dart';
part '${FEATURE_SNAKE}_model.g.dart';

@freezed
abstract class ${FEATURE_PASCAL}Model with _\$${FEATURE_PASCAL}Model {
  const ${FEATURE_PASCAL}Model._();

  const factory ${FEATURE_PASCAL}Model({
    @Default('') String id,
    @Default('') String name,
    @Default(0.0) double price,
  }) = _${FEATURE_PASCAL}Model;

  factory ${FEATURE_PASCAL}Model.fromJson(Map<String, dynamic> json) =>
      _\$${FEATURE_PASCAL}ModelFromJson(json);
}
EOF

# 2. Remote Data Source
cat <<EOF > "$TARGET_DIR/data_sources/${FEATURE_SNAKE}_remote_data_source.dart"
import '../../../core/network/api_client.dart';
import '../models/${FEATURE_SNAKE}_model.dart';

abstract class ${FEATURE_PASCAL}RemoteDataSource {
  Future<List<${FEATURE_PASCAL}Model>> getItems();
  Future<${FEATURE_PASCAL}Model> getItemById(String id);
}

class ${FEATURE_PASCAL}RemoteDataSourceImpl implements ${FEATURE_PASCAL}RemoteDataSource {
  final ApiClient apiClient;

  ${FEATURE_PASCAL}RemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<${FEATURE_PASCAL}Model>> getItems() async {
    final response = await apiClient.get('/api/${FEATURE_SNAKE}s');
    final list = response.data as List;
    return list.map((e) => ${FEATURE_PASCAL}Model.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<${FEATURE_PASCAL}Model> getItemById(String id) async {
    final response = await apiClient.get('/api/${FEATURE_SNAKE}s/\$id');
    return ${FEATURE_PASCAL}Model.fromJson(response.data as Map<String, dynamic>);
  }
}
EOF

# 3. Repository
cat <<EOF > "$TARGET_DIR/repositories/${FEATURE_SNAKE}_repository.dart"
import '../data_sources/${FEATURE_SNAKE}_remote_data_source.dart';
import '../models/${FEATURE_SNAKE}_model.dart';

abstract class ${FEATURE_PASCAL}Repository {
  Future<List<${FEATURE_PASCAL}Model>> getItems();
  Future<${FEATURE_PASCAL}Model> getItemById(String id);
}

class ${FEATURE_PASCAL}RepositoryImpl implements ${FEATURE_PASCAL}Repository {
  final ${FEATURE_PASCAL}RemoteDataSource remoteDataSource;

  ${FEATURE_PASCAL}RepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<${FEATURE_PASCAL}Model>> getItems() => remoteDataSource.getItems();

  @override
  Future<${FEATURE_PASCAL}Model> getItemById(String id) => remoteDataSource.getItemById(id);
}
EOF

# 4. Controller
cat <<EOF > "$TARGET_DIR/controllers/${FEATURE_SNAKE}_controller.dart"
import 'package:get/get.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../models/${FEATURE_SNAKE}_model.dart';
import '../repositories/${FEATURE_SNAKE}_repository.dart';

class ${FEATURE_PASCAL}Controller extends GetxController {
  final ${FEATURE_PASCAL}Repository repository;

  ${FEATURE_PASCAL}Controller({required this.repository});

  final RxList<${FEATURE_PASCAL}Model> items = <${FEATURE_PASCAL}Model>[].obs;
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
        title: 'Kesalahan',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
EOF

# 5. Binding
cat <<EOF > "$TARGET_DIR/bindings/${FEATURE_SNAKE}_binding.dart"
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../controllers/${FEATURE_SNAKE}_controller.dart';
import '../data_sources/${FEATURE_SNAKE}_remote_data_source.dart';
import '../repositories/${FEATURE_SNAKE}_repository.dart';

class ${FEATURE_PASCAL}Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<${FEATURE_PASCAL}RemoteDataSource>(
      () => ${FEATURE_PASCAL}RemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
    );
    Get.lazyPut<${FEATURE_PASCAL}Repository>(
      () => ${FEATURE_PASCAL}RepositoryImpl(remoteDataSource: Get.find<${FEATURE_PASCAL}RemoteDataSource>()),
    );
    Get.lazyPut<${FEATURE_PASCAL}Controller>(
      () => ${FEATURE_PASCAL}Controller(repository: Get.find<${FEATURE_PASCAL}Repository>()),
    );
  }
}
EOF

# 6. Page
cat <<EOF > "$TARGET_DIR/pages/${FEATURE_SNAKE}_page.dart"
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/empty_state.dart';
import '../controllers/${FEATURE_SNAKE}_controller.dart';

class ${FEATURE_PASCAL}Page extends GetView<${FEATURE_PASCAL}Controller> {
  const ${FEATURE_PASCAL}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('${FEATURE_PASCAL}'),
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
            description: 'Data ${FEATURE_SNAKE} belum tersedia.',
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
                subtitle: Text('ID: \${item.id}'),
              );
            },
          ),
        );
      }),
    );
  }
}
EOF

chmod +x "$TARGET_DIR"/*.dart 2>/dev/null || true

echo "Feature $FEATURE_PASCAL scaffolded successfully at $TARGET_DIR!"
echo "Next steps:"
echo "1. Run: dart run build_runner build --delete-conflicting-outputs"
echo "2. Add route in lib/app/routes/app_routes.dart and app_pages.dart"
EOF
