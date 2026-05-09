import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/print_order.dart';
import '../../domain/entities/order_status.dart';
import '../providers/auth_controller.dart';
import '../providers/orders_controller.dart';

class OrderDetailScreen extends StatelessWidget {
  static const routeName = '/order-detail';
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final ordersController = context.watch<OrdersController>();
    final userId = auth.currentUser?.id ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: StreamBuilder<List<PrintOrder>>(
        stream: ordersController.watchOrdersForUser(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final order = snapshot.data!.firstWhere(
            (item) => item.id == orderId,
            orElse: () => const PrintOrder(
              id: '',
              customerId: '',
              fileName: '',
              fileUrl: '',
              paperSize: '',
              isColor: false,
              copies: 0,
              binding: '',
              price: 0,
              status: OrderStatus.pending,
              createdAt: DateTime(1970),
            ),
          );
          if (order.id.isEmpty) {
            return const Center(child: Text('Order not found.'));
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.fileName, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('Status: ${order.status.label}'),
                const SizedBox(height: 8),
                Text('Paper Size: ${order.paperSize}'),
                Text('Color: ${order.isColor ? 'Color' : 'B/W'}'),
                Text('Copies: ${order.copies}'),
                Text('Binding: ${order.binding}'),
                const SizedBox(height: 8),
                Text('Price: ${order.price.toStringAsFixed(2)}'),
                const SizedBox(height: 16),
                Text('Uploaded file: ${order.fileUrl}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
