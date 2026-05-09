import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/entities/product_order.dart';
import '../providers/auth_controller.dart';
import '../providers/cart_controller.dart';
import '../providers/product_orders_controller.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});

  Future<void> _confirmOrder(BuildContext context) async {
    final cart = context.read<CartController>();
    final auth = context.read<AuthController>();
    final controller = context.read<ProductOrdersController>();
    if (cart.items.isEmpty) return;
    final order = ProductOrder(
      id: '',
      customerId: auth.currentUser?.id ?? '',
      items: cart.items,
      totalAmount: cart.total,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
    );
    await controller.submitOrder(order);
    cart.clear();
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartController>();
    final productOrders = context.watch<ProductOrdersController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: cart.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  return Card(
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text('Qty: ${item.quantity}'),
                      trailing: Text(item.totalPrice.toStringAsFixed(2)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total'),
                Text(cart.total.toStringAsFixed(2)),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: productOrders.isLoading
                    ? null
                    : () => _confirmOrder(context),
                child: Text(
                  productOrders.isLoading ? 'Submitting...' : 'Confirm Order (COD)',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
