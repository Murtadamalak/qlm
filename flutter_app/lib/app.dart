import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/config/app_routes.dart';
import 'presentation/providers/auth_controller.dart';
import 'presentation/providers/cart_controller.dart';
import 'presentation/providers/orders_controller.dart';
import 'presentation/providers/products_controller.dart';
import 'presentation/providers/pricing_controller.dart';
import 'presentation/providers/support_controller.dart';
import 'presentation/providers/admin_controller.dart';
import 'presentation/providers/product_orders_controller.dart';
import 'presentation/screens/login_screen.dart';

class ELibraryPrintingApp extends StatelessWidget {
  const ELibraryPrintingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => CartController()),
        ChangeNotifierProvider(create: (_) => OrdersController()),
        ChangeNotifierProvider(create: (_) => ProductsController()),
        ChangeNotifierProvider(create: (_) => PricingController()),
        ChangeNotifierProvider(create: (_) => SupportController()),
        ChangeNotifierProvider(create: (_) => AdminController()),
        ChangeNotifierProvider(create: (_) => ProductOrdersController()),
      ],
      child: MaterialApp(
        title: 'E-Library & Printing',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        initialRoute: LoginScreen.routeName,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
