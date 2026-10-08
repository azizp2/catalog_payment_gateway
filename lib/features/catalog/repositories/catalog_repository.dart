import '../data_sources/catalog_remote_data_source.dart';
import '../models/create_product_request.dart';
import '../models/product_model.dart';

abstract class CatalogRepository {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(String id);
  Future<ProductModel> createProduct(CreateProductRequest request);
}

class CatalogRepositoryImpl implements CatalogRepository {
  final CatalogRemoteDataSource remoteDataSource;

  CatalogRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ProductModel>> getProducts() => remoteDataSource.getProducts();

  @override
  Future<ProductModel> getProductById(String id) => remoteDataSource.getProductById(id);

  @override
  Future<ProductModel> createProduct(CreateProductRequest request) =>
      remoteDataSource.createProduct(request);
}
