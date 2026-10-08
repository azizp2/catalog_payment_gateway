import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/create_product_request.dart';
import '../models/product_model.dart';

abstract class CatalogRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(String id);
  Future<ProductModel> createProduct(CreateProductRequest request);
}

class CatalogRemoteDataSourceImpl implements CatalogRemoteDataSource {
  final ApiClient apiClient;

  CatalogRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await apiClient.get<List<dynamic>>(ApiEndpoints.products);
    final data = response.data ?? [];
    return data.map((json) => ProductModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final response = await apiClient.get<Map<String, dynamic>>(ApiEndpoints.productById(id));
    return ProductModel.fromJson(response.data!);
  }

  @override
  Future<ProductModel> createProduct(CreateProductRequest request) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.products,
      data: request.toJson(),
    );
    return ProductModel.fromJson(response.data!);
  }
}
