import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/presentation/products/bloc/product_bloc.dart';
import 'package:trucky/presentation/products/bloc/product_event.dart';

import '../../../helpers/product_test_harness.dart';

void main() {
  group('ProductScreen', () {
    testWidgets('loads and lists the sample products', (tester) async {
      await pumpRouterWithProductApp(tester);

      expect(find.text('Engine Oil'), findsOneWidget);
      expect(find.text('Brake Pads'), findsOneWidget);
      expect(find.text('Battery'), findsOneWidget);
      expect(find.text('Total Stock Value'), findsOneWidget);
    });

    testWidgets('hides balances when the visibility toggle is tapped',
        (tester) async {
      await pumpRouterWithProductApp(tester);

      expect(find.text('Purchase Value'), findsNWidgets(5));

      final visibilityOff = find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                AppAssets.images.visibilityOff,
      );
      // The app bar icon image has no resolved pixels in the test harness, so
      // warnIfMissed is disabled; the tap still reaches the parent toggle.
      await tester.tap(visibilityOff, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.text('*******'), findsNWidgets(5));
    });

    testWidgets('tapping a product navigates to the dashboard',
        (tester) async {
      await pumpRouterWithProductApp(tester);

      await tester.tap(find.text('Engine Oil'));
      await tester.pumpAndSettle();

      expect(find.text('Stock Available'), findsOneWidget);
      expect(find.text('Stock Value'), findsOneWidget);
      expect(find.text('Initial Stock'), findsOneWidget);
    });

    testWidgets('FAB navigates to the add product screen', (tester) async {
      await pumpRouterWithProductApp(tester);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // AppBar title and bottom navigation button both read "Add Product".
      expect(find.text('Add Product'), findsNWidgets(2));
      // "Product Name" appears once as the field label and once as its hint.
      expect(find.text('Product Name'), findsNWidgets(2));
    });
  });

  group('ProductScreen (pre-loaded bloc)', () {
    testWidgets('does not re-seed sample data once loaded', (tester) async {
      final bloc = ProductBloc();
      bloc.add(const LoadProductsEvent());
      await tester.pump();

      expect(bloc.state.isLoaded, isTrue);
      final loadedIds = bloc.state.products.map((p) => p.id).toList();

      await pumpRouterWithProductApp(tester, bloc: bloc);

      expect(bloc.state.products.map((p) => p.id), equals(loadedIds));
      expect(bloc.state.products.length, 5);

      bloc.close();
    });
  });
}
