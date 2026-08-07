import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:trucky/core/constants/route_paths.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_bloc.dart';
import 'package:trucky/presentation/client_supplier/screens/add_client_supp_screen.dart';
import 'package:trucky/presentation/client_supplier/screens/client_supp_dashboard_screen.dart';
import 'package:trucky/presentation/client_supplier/screens/client_supp_page.dart';

import 'fake_client_supp_repository.dart';

/// Builds a router with the clients/suppliers routes and a stub home route.
GoRouter clientSuppRouter({String initialLocation = RoutePaths.clients}) {
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
        path: RoutePaths.clients,
        name: 'clients',
        builder: (context, state) => const ClientSuppPage(),
      ),
      GoRoute(
        path: RoutePaths.suppliers,
        name: 'suppliers',
        builder: (context, state) => const ClientSuppPage(),
      ),
      GoRoute(
        path: RoutePaths.addClientSupp,
        name: 'addClientSupp',
        builder: (context, state) => const AddClientSuppScreen(),
      ),
      GoRoute(
        path: RoutePaths.clientSuppDashboard,
        name: 'clientSuppDashboard',
        builder: (context, state) => const ClientSuppDashboardScreen(),
      ),
    ],
  );
}

/// Pumps the clients/suppliers router for navigation-aware tests.
Future<void> pumpRouterWithClientSuppApp(
  WidgetTester tester, {
  ClientSuppBloc? bloc,
  String initialLocation = RoutePaths.clients,
}) async {
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(412, 892),
      minTextAdapt: true,
      fontSizeResolver: FontSizeResolvers.height,
      builder: (context, child) => BlocProvider<ClientSuppBloc>(
        create: (_) => bloc ?? buildClientSuppBloc(),
        child: MaterialApp.router(
          routerConfig: clientSuppRouter(initialLocation: initialLocation),
          debugShowCheckedModeBanner: false,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
