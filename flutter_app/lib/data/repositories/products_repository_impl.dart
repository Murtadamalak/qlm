import '../../domain/entities/product.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_remote_data_source.dart';
import '../models/product_model.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource _remoteDataSource;

  ProductsRepositoryImpl({ProductsRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? ProductsRemoteDataSource();

  @override
  Stream<List<Product>> watchProducts() => _remoteDataSource.watchProducts();

  @override
  Future<void> addProduct(Product product) {
    final model = ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      isActive: product.isActive,
    );
    return _remoteDataSource.addProduct(model);
  }

  @override
  Future<void> updateProduct(Product product) {
    final model = ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      isActive: product.isActive,
    );
    return _remoteDataSource.updateProduct(model);
  }

  @override
  Future<void> deleteProduct(String productId) =>
      _remoteDataSource.deleteProduct(productId);
}
