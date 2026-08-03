import 'package:go_router/go_router.dart';
import 'package:trucky/core/constants/route_paths.dart';
import 'package:trucky/presentation/home/screens/home_screen.dart';
import 'package:trucky/presentation/products/screens/product_screen.dart';

/// App-level router configuration (composition root).
final appRouter = GoRouter(
  initialLocation: RoutePaths.home,
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
  ],
);
