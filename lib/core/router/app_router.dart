import 'package:go_router/go_router.dart';
import 'package:trucky/core/constants/route_paths.dart';
import 'package:trucky/core/router/navigator_key.dart';
import 'package:trucky/presentation/home/screens/home_screen.dart';
import 'package:trucky/presentation/products/screens/add_product_screen.dart';
import 'package:trucky/presentation/products/screens/product_dashboard_screen.dart';
import 'package:trucky/presentation/products/screens/product_screen.dart';

/// App-level router configuration (composition root).
final appRouter = GoRouter(
  initialLocation: RoutePaths.home,
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
      path: RoutePaths.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: RoutePaths.products,
      name: 'products',
      builder: (context, state) => const ProductScreen(),
    ),
    GoRoute(
      path: RoutePaths.addProduct,
      name: 'addProduct',
      builder: (context, state) => const AddProductScreen(),
    ),
    GoRoute(
      path: RoutePaths.productDashboard,
      name: 'productDashboard',
      builder: (context, state) => const ProductDashboardScreen(),
    ),
  ],
);
