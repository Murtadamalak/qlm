import 'package:flutter/material.dart';
import '../../data/repositories/products_repository_impl.dart';
import '../../domain/entities/product.dart';

class ProductsController extends ChangeNotifier {
  final ProductsRepositoryImpl _repository;

  ProductsController({ProductsRepositoryImpl? repository})
      : _repository = repository ?? ProductsRepositoryImpl();

  Stream<List<Product>> watchProducts() => _repository.watchProducts();

  Future<void> addProduct(Product product) => _repository.addProduct(product);

  Future<void> updateProduct(Product product) =>
      _repository.updateProduct(product);

  Future<void> deleteProduct(String productId) =>
      _repository.deleteProduct(productId);
}
