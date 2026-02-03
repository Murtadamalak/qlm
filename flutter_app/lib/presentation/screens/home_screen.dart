import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_controller.dart';
import 'print_order_screen.dart';
import 'store_screen.dart';
import 'orders_screen.dart';
import 'admin_dashboard_screen.dart';
import 'login_screen.dart';
import 'support_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Library & Printing'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authController.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello ${authController.currentUser?.phoneNumber ?? ''}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _FeatureCard(
                    title: 'Printing Services',
                    icon: Icons.print,
                    onTap: () => Navigator.pushNamed(
                      context,
                      PrintOrderScreen.routeName,
                    ),
                  ),
                  _FeatureCard(
                    title: 'Products Store',
                    icon: Icons.store,
                    onTap: () => Navigator.pushNamed(
                      context,
                      StoreScreen.routeName,
                    ),
                  ),
                  _FeatureCard(
                    title: 'My Orders',
                    icon: Icons.receipt_long,
                    onTap: () => Navigator.pushNamed(
                      context,
                      OrdersScreen.routeName,
                    ),
                  ),
                  _FeatureCard(
                    title: 'Customer Support',
                    icon: Icons.support_agent,
                    onTap: () => Navigator.pushNamed(
                      context,
                      SupportScreen.routeName,
                    ),
                  ),
                  if (authController.currentUser?.role == 'admin')
                    _FeatureCard(
                      title: 'Admin Dashboard',
                      icon: Icons.admin_panel_settings,
                      onTap: () => Navigator.pushNamed(
                        context,
                        AdminDashboardScreen.routeName,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40),
              const SizedBox(height: 12),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
