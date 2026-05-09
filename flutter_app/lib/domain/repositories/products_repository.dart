import '../entities/product.dart';

abstract class ProductsRepository {
  Stream<List<Product>> watchProducts();
  Future<void> addProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String productId);
}
