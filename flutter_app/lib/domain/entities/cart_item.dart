import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String productId;
  final String name;
  final double unitPrice;
  final int quantity;

  const CartItem({
    required this.productId,
    required this.name,
    required this.unitPrice,
    required this.quantity,
  });

  double get totalPrice => unitPrice * quantity;

  @override
  List<Object?> get props => [productId, name, unitPrice, quantity];
}
