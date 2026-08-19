import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trucky/presentation/products/bloc/product_bloc.dart';
import 'package:trucky/presentation/products/bloc/product_event.dart';

import '../../../helpers/fake_product_repository.dart';
import '../../../helpers/product_test_harness.dart';

void main() {
  group('AddProductScreen', () {
    final addButton =
        find.widgetWithText(ElevatedButton, 'Add Product');

    /// Pumps the products list, then navigates to the Add Product screen via
    /// the FAB so that a successful add can pop back to a real route.
    Future<void> pumpToAddScreen(WidgetTester tester,
        {ProductBloc? bloc}) async {
      final b = bloc ?? buildProductBloc();
      b.add(const LoadProductsEvent());
      await tester.pump();

      await pumpRouterWithProductApp(tester, bloc: b);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
    }

    testWidgets('shows validation errors when required fields are empty',
        (tester) async {
      await pumpToAddScreen(tester);

      await tester.tap(addButton);
      await tester.pumpAndSettle();

      expect(find.text('* Product name is required'), findsOneWidget);
      expect(find.text('* Purchase price is required'), findsOneWidget);
      expect(find.text('* Selling price is required'), findsOneWidget);
    });

    testWidgets('adds a product to the bloc when the form is valid',
        (tester) async {
      final bloc = buildProductBloc();
      await pumpToAddScreen(tester, bloc: bloc);

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Spark Plugs');
      await tester.enterText(fields.at(2), '40');
      await tester.enterText(fields.at(3), '65');
      await tester.enterText(fields.at(4), '8');
      await tester.enterText(fields.at(5), '4');

      await tester.tap(addButton);
      await tester.pumpAndSettle();

      expect(bloc.state.products.length, 6);
      final product = bloc.state.products.last;
      expect(product.productName, 'Spark Plugs');
      expect(product.purchasePrice, 40);
      expect(product.sellingPrice, 65);
      expect(product.availableStock, 8);
      expect(product.quantityPerPackage, '4');
    });

    testWidgets('does not add a product with a duplicate name',
        (tester) async {
      final bloc = buildProductBloc();
      await pumpToAddScreen(tester, bloc: bloc);

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Spark Plugs');
      await tester.enterText(fields.at(2), '40');
      await tester.enterText(fields.at(3), '65');
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      expect(bloc.state.products.length, 6);

      // Add the same product again; the duplicate guard must block it.
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(fields.at(0), 'Spark Plugs');
      await tester.enterText(fields.at(2), '40');
      await tester.enterText(fields.at(3), '65');
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      expect(bloc.state.products.length, 6);
    });
  });
}
