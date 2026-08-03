import 'package:flutter_test/flutter_test.dart';
import 'package:trucky/presentation/products/bloc/product_bloc.dart';
import 'package:trucky/presentation/products/bloc/product_event.dart';

/// Flushes the bloc's microtask queue so synchronous handlers complete.
Future<void> pumpEventQueue() async {
  for (var i = 0; i < 10; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProductBloc', () {
    late ProductBloc bloc;

    setUp(() {
      bloc = ProductBloc();
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state has no products and is not loaded', () {
      expect(bloc.state.products, isEmpty);
      expect(bloc.state.isLoaded, isFalse);
      expect(bloc.state.totalStockValue, 0);
      expect(bloc.state.selectedProduct, isNull);
    });

    group('LoadProductsEvent', () {
      test('seeds the sample products and computes total stock value', () async {
        bloc.add(const LoadProductsEvent());
        await pumpEventQueue();

        expect(bloc.state.isLoaded, isTrue);
        expect(bloc.state.products.length, 5);
        expect(bloc.state.products.first.productName, 'Engine Oil');
        // sum of (availableStock * sellingPrice)
        expect(bloc.state.totalStockValue, closeTo(12990.0, 0.001));
      });

      test('assigns weightedAverageCost from purchase price', () async {
        bloc.add(const LoadProductsEvent());
        await pumpEventQueue();

        final product = bloc.state.products.first;
        expect(product.weightedAverageCost, product.purchasePrice);
      });

      test('does not duplicate products on repeated load', () async {
        bloc.add(const LoadProductsEvent());
        await pumpEventQueue();
        final firstLoadIds = bloc.state.products.map((p) => p.id).toList();

        bloc.add(const LoadProductsEvent());
        await pumpEventQueue();

        // A reload replaces the list rather than appending to it.
        expect(bloc.state.products.length, 5);
        expect(
          bloc.state.products.map((p) => p.id),
          isNot(equals(firstLoadIds)),
        );
      });
    });

    group('AddProductEvent', () {
      setUp(() async {
        bloc.add(const LoadProductsEvent());
        await pumpEventQueue();
      });

      test('appends the product and updates the total stock value', () async {
        bloc.add(
          const AddProductEvent(
            productName: 'Spark Plugs',
            productSKU: 'SP-001',
            purchasePrice: 40.0,
            sellingPrice: 65.0,
            initialQuantity: 8,
            quantityPerPackage: '4',
          ),
        );
        await pumpEventQueue();

        expect(bloc.state.products.length, 6);
        final added = bloc.state.products.last;
        expect(added.productName, 'Spark Plugs');
        expect(added.productSKU, 'SP-001');
        expect(added.availableStock, 8);
        expect(added.weightedAverageCost, 40.0);
        // previous total (12990) + 8 * 65 (520) = 13510
        expect(bloc.state.totalStockValue, closeTo(13510.0, 0.001));
      });

      test('rejects a product with a duplicate name', () async {
        final countBefore = bloc.state.products.length;
        bloc.add(
          const AddProductEvent(
            productName: 'Engine Oil',
            purchasePrice: 1,
            sellingPrice: 2,
          ),
        );
        await pumpEventQueue();

        expect(bloc.state.products.length, countBefore);
      });

      test('ignores a product with an empty name', () async {
        final countBefore = bloc.state.products.length;
        bloc.add(
          const AddProductEvent(
            productName: '',
            purchasePrice: 10,
            sellingPrice: 20,
          ),
        );
        await pumpEventQueue();

        expect(bloc.state.products.length, countBefore);
      });
    });

    group('RemoveProductEvent', () {
      setUp(() async {
        bloc.add(const LoadProductsEvent());
        await pumpEventQueue();
      });

      test('removes the product and recomputes the total stock value', () async {
        final removedId = bloc.state.products.first.id!;
        final removedValue = bloc.state.products.first.totalValue;
        final expected = bloc.state.totalStockValue - removedValue;

        bloc.add(RemoveProductEvent(id: removedId));
        await pumpEventQueue();

        expect(bloc.state.products.length, 4);
        expect(
          bloc.state.products.any((p) => p.id == removedId),
          isFalse,
        );
        expect(bloc.state.totalStockValue, closeTo(expected, 0.001));
      });

      test('clears the selected product when it is the removed one', () async {
        bloc.add(const SelectProductEvent(id: 1));
        await pumpEventQueue();
        expect(bloc.state.selectedProduct, isNotNull);
        expect(bloc.state.productDetailsList, isNotEmpty);

        bloc.add(const RemoveProductEvent(id: 1));
        await pumpEventQueue();

        expect(bloc.state.selectedProduct, isNull);
        expect(bloc.state.productDetailsList, isEmpty);
      });

      test('keeps the selection when a different product is removed', () async {
        bloc.add(const SelectProductEvent(id: 1));
        await pumpEventQueue();

        bloc.add(const RemoveProductEvent(id: 2));
        await pumpEventQueue();

        expect(bloc.state.selectedProduct?.id, 1);
      });
    });

    group('SelectProductEvent', () {
      setUp(() async {
        bloc.add(const LoadProductsEvent());
        await pumpEventQueue();
      });

      test('sets the selected product and its initial stock detail', () async {
        bloc.add(const SelectProductEvent(id: 1));
        await pumpEventQueue();

        expect(bloc.state.selectedProduct?.id, 1);
        expect(bloc.state.productDetailsList.length, 1);
        final detail = bloc.state.productDetailsList.first;
        expect(detail.productId, 1);
        expect(detail.paymentType, 'Initial Stock');
        expect(detail.quantity, bloc.state.selectedProduct!.availableStock);
      });

      test('ignores an unknown product id', () async {
        bloc.add(const SelectProductEvent(id: 999));
        await pumpEventQueue();

        expect(bloc.state.selectedProduct, isNull);
        expect(bloc.state.productDetailsList, isEmpty);
      });
    });

    group('Balance visibility toggles', () {
      test('toggles the product balance flag', () async {
        expect(bloc.state.hideProductTotalBalance, isFalse);
        bloc.add(const ToggleProductBalanceVisibilityEvent());
        await pumpEventQueue();
        expect(bloc.state.hideProductTotalBalance, isTrue);
        bloc.add(const ToggleProductBalanceVisibilityEvent());
        await pumpEventQueue();
        expect(bloc.state.hideProductTotalBalance, isFalse);
      });

      test('toggles the dashboard balance flag independently', () async {
        expect(bloc.state.hideDashboardTotalBalance, isFalse);
        bloc.add(const ToggleDashboardBalanceVisibilityEvent());
        await pumpEventQueue();
        expect(bloc.state.hideDashboardTotalBalance, isTrue);
        expect(bloc.state.hideProductTotalBalance, isFalse);
      });
    });

    group('Product model getters', () {
      test('profit is selling minus purchase price', () {
        const product = Product(
          productName: 'A',
          purchasePrice: 80,
          sellingPrice: 100,
          availableStock: 5,
        );
        expect(product.profit, 20);
        expect(product.isInStock, isTrue);
        expect(product.totalValue, 500);
        expect(product.purchaseValue, 500);
      });

      test('effectiveCost falls back to purchasePrice', () {
        const product = Product(
          productName: 'A',
          purchasePrice: 80,
          sellingPrice: 100,
          availableStock: 0,
        );
        expect(product.effectiveCost, 80);
        expect(product.isInStock, isFalse);
      });

      test('effectiveCost prefers weightedAverageCost', () {
        const product = Product(
          productName: 'A',
          purchasePrice: 80,
          sellingPrice: 100,
          weightedAverageCost: 60,
        );
        expect(product.effectiveCost, 60);
      });
    });
  });
}
