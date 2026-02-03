import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product.dart';
import '../providers/cart_controller.dart';
import '../providers/products_controller.dart';
import 'cart_screen.dart';

class StoreScreen extends StatelessWidget {
  static const routeName = '/store';

  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsController = context.watch<ProductsController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products Store'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, CartScreen.routeName),
          ),
        ],
      ),
      body: StreamBuilder<List<Product>>(
        stream: productsController.watchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final products = snapshot.data ?? [];
          if (products.isEmpty) {
            return const Center(child: Text('No products available.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final product = products[index];
              return _ProductTile(product: product);
            },
          );
        },
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final Product product;

  const _ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartController>();
    return Card(
      child: ListTile(
        leading: product.imageUrl.isNotEmpty
            ? Image.network(product.imageUrl, width: 48, height: 48, fit: BoxFit.cover)
            : const Icon(Icons.inventory_2),
        title: Text(product.name),
        subtitle: Text(product.description),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(product.price.toStringAsFixed(2)),
            const SizedBox(height: 6),
            ElevatedButton(
              onPressed: () => cart.addItem(product),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
