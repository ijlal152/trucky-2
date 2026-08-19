import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:trucky/core/constants/route_paths.dart';
import 'package:trucky/presentation/products/bloc/product_bloc.dart';
import 'package:trucky/presentation/products/screens/add_product_screen.dart';
import 'package:trucky/presentation/products/screens/product_dashboard_screen.dart';
import 'package:trucky/presentation/products/screens/product_screen.dart';

import 'fake_product_repository.dart';

/// Builds a router with the products routes and a stub home route.
GoRouter productsRouter({String initialLocation = RoutePaths.products}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: RoutePaths.home,
        name: 'home',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('HOME'))),
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
}

/// Pumps [widget] inside a [ProductBloc] + router + ScreenUtil harness.
Future<void> pumpWithProductApp(
  WidgetTester tester,
  Widget widget, {
  ProductBloc? bloc,
}) async {
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(412, 892),
      minTextAdapt: true,
      fontSizeResolver: FontSizeResolvers.height,
      builder: (context, child) => BlocProvider<ProductBloc>(
        create: (_) => bloc ?? buildProductBloc(),
        child: MaterialApp(
          home: Scaffold(body: child),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// Pumps the products router (full app shell) for navigation-aware tests.
Future<void> pumpRouterWithProductApp(
  WidgetTester tester, {
  ProductBloc? bloc,
  String initialLocation = RoutePaths.products,
}) async {
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(412, 892),
      minTextAdapt: true,
      fontSizeResolver: FontSizeResolvers.height,
      builder: (context, child) => BlocProvider<ProductBloc>(
        create: (_) => bloc ?? buildProductBloc(),
        child: MaterialApp.router(
          routerConfig: productsRouter(initialLocation: initialLocation),
          debugShowCheckedModeBanner: false,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
