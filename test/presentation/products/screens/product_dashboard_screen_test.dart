import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trucky/presentation/products/bloc/product_bloc.dart';
import 'package:trucky/presentation/products/bloc/product_event.dart';

import '../../../helpers/product_test_harness.dart';

void main() {
  group('ProductDashboardScreen', () {
    /// Pumps the products list and navigates to the selected product's
    /// dashboard, mirroring real navigation so pop() has a route to return to.
    Future<void> pumpToDashboard(
      WidgetTester tester, {
      required ProductBloc bloc,
    }) async {
      bloc.add(const LoadProductsEvent());
      await tester.pump();

      await pumpRouterWithProductApp(tester, bloc: bloc);

      await tester.tap(find.text('Engine Oil'));
      await tester.pumpAndSettle();
    }

    testWidgets('renders the selected product name in the app bar',
        (tester) async {
      final bloc = ProductBloc();
      await pumpToDashboard(tester, bloc: bloc);

      expect(find.text('Engine Oil'), findsOneWidget);
      bloc.close();
    });

    testWidgets('shows stock info and an initial stock detail',
        (tester) async {
      final bloc = ProductBloc();
      await pumpToDashboard(tester, bloc: bloc);

      expect(find.text('Stock Available'), findsOneWidget);
      expect(find.text('Stock Value'), findsOneWidget);
      expect(find.text('Price'), findsOneWidget);
      expect(find.text('Initial Stock'), findsOneWidget);

      bloc.close();
    });

    testWidgets('deletes the product from the popup menu', (tester) async {
      final bloc = ProductBloc();
      await pumpToDashboard(tester, bloc: bloc);

      await tester.tap(find.byType(PopupMenuButton<int>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(bloc.state.products.length, 4);
      expect(bloc.state.selectedProduct, isNull);
      // Popped back to the products list, which no longer shows the product.
      expect(find.text('Engine Oil'), findsNothing);

      bloc.close();
    });
  });
}
