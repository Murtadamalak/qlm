import 'package:flutter/material.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/print_order_screen.dart';
import '../../presentation/screens/store_screen.dart';
import '../../presentation/screens/cart_screen.dart';
import '../../presentation/screens/orders_screen.dart';
import '../../presentation/screens/order_detail_screen.dart';
import '../../presentation/screens/admin_dashboard_screen.dart';
import '../../presentation/screens/support_screen.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeScreen.routeName:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case PrintOrderScreen.routeName:
        return MaterialPageRoute(builder: (_) => const PrintOrderScreen());
      case StoreScreen.routeName:
        return MaterialPageRoute(builder: (_) => const StoreScreen());
      case CartScreen.routeName:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case OrdersScreen.routeName:
        return MaterialPageRoute(builder: (_) => const OrdersScreen());
      case OrderDetailScreen.routeName:
        final orderId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => OrderDetailScreen(orderId: orderId ?? ''),
        );
      case AdminDashboardScreen.routeName:
        return MaterialPageRoute(builder: (_) => const AdminDashboardScreen());
      case SupportScreen.routeName:
        return MaterialPageRoute(builder: (_) => const SupportScreen());
      case LoginScreen.routeName:
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
