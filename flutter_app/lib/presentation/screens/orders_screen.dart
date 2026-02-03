import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/print_order.dart';
import '../../domain/entities/product_order.dart';
import '../providers/auth_controller.dart';
import '../providers/orders_controller.dart';
import '../providers/product_orders_controller.dart';
import 'order_detail_screen.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final ordersController = context.watch<OrdersController>();
    final productOrdersController = context.watch<ProductOrdersController>();
    final userId = auth.currentUser?.id ?? '';

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Print Orders'),
              Tab(text: 'Products'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder<List<PrintOrder>>(
              stream: ordersController.watchOrdersForUser(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final orders = snapshot.data ?? [];
                if (orders.isEmpty) {
                  return const Center(child: Text('No print orders yet.'));
                }
                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return ListTile(
                      title: Text(order.fileName),
                      subtitle: Text('Status: ${order.status.label}'),
                      trailing: Text(order.price.toStringAsFixed(2)),
                      onTap: () => Navigator.pushNamed(
                        context,
                        OrderDetailScreen.routeName,
                        arguments: order.id,
                      ),
                    );
                  },
                );
              },
            ),
            StreamBuilder<List<ProductOrder>>(
              stream: productOrdersController.watchOrdersForUser(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final orders = snapshot.data ?? [];
                if (orders.isEmpty) {
                  return const Center(child: Text('No product orders yet.'));
                }
                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return ListTile(
                      title: Text('Items: ${order.items.length}'),
                      subtitle: Text('Status: ${order.status.label}'),
                      trailing: Text(order.totalAmount.toStringAsFixed(2)),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
