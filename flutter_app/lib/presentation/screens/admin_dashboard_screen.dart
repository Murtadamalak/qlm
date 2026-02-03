import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/entities/print_order.dart';
import '../../domain/entities/product.dart';
import '../providers/admin_controller.dart';

class AdminDashboardScreen extends StatelessWidget {
  static const routeName = '/admin';

  const AdminDashboardScreen({super.key});

  Future<void> _showAddProductDialog(
    BuildContext context,
    AdminController controller,
  ) async {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final descriptionController = TextEditingController();
    final imageController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Product'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
              TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
              TextField(controller: imageController, decoration: const InputDecoration(labelText: 'Image URL')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final product = Product(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameController.text.trim(),
                description: descriptionController.text.trim(),
                price: double.tryParse(priceController.text.trim()) ?? 0,
                imageUrl: imageController.text.trim(),
                isActive: true,
              );
              controller.addProduct(product);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateStatus(
    BuildContext context,
    AdminController controller,
    String orderId,
  ) async {
    final selected = await showModalBottomSheet<OrderStatus>(
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: OrderStatus.values
            .map(
              (status) => ListTile(
                title: Text(status.label),
                onTap: () => Navigator.pop(context, status),
              ),
            )
            .toList(),
      ),
    );
    if (selected != null) {
      await controller.updateOrderStatus(orderId, selected);
    }
  }

  Future<void> _sendNotification(
    BuildContext context,
    AdminController controller,
    PrintOrder order,
  ) async {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Notification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: bodyController,
              decoration: const InputDecoration(labelText: 'Message'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              controller.sendNotification(
                userId: order.customerId,
                title: titleController.text.trim(),
                body: bodyController.text.trim(),
                data: {'order_id': order.id},
              );
              Navigator.pop(context);
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AdminController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () => _showAddProductDialog(context, controller),
          ),
        ],
      ),
      body: StreamBuilder<List<PrintOrder>>(
        stream: controller.watchAllOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return const Center(child: Text('No print orders found.'));
          }
          return ListView.separated(
            itemCount: orders.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                title: Text(order.fileName),
                subtitle: Text('Status: ${order.status.label} | ${order.paperSize}'),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'status') {
                      _updateStatus(context, controller, order.id);
                    } else if (value == 'notify') {
                      _sendNotification(context, controller, order);
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'status', child: Text('Update Status')),
                    PopupMenuItem(value: 'notify', child: Text('Notify Customer')),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
