import 'package:flutter/material.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/product.dart';

class CartController extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList(growable: false);

  double get total => _items.values.fold(0, (sum, item) => sum + item.totalPrice);

  void addItem(Product product) {
    final existing = _items[product.id];
    if (existing != null) {
      _items[product.id] = CartItem(
        productId: existing.productId,
        name: existing.name,
        unitPrice: existing.unitPrice,
        quantity: existing.quantity + 1,
      );
    } else {
      _items[product.id] = CartItem(
        productId: product.id,
        name: product.name,
        unitPrice: product.price,
        quantity: 1,
      );
    }
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (!_items.containsKey(productId)) return;
    if (quantity <= 0) {
      _items.remove(productId);
    } else {
      final item = _items[productId]!;
      _items[productId] = CartItem(
        productId: item.productId,
        name: item.name,
        unitPrice: item.unitPrice,
        quantity: quantity,
      );
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
