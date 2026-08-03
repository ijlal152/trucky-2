import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trucky/presentation/home/widgets/dashboard_sheet_widget.dart';

import '../../helpers/widget_harness.dart';

void main() {
  group('DashBoardSheetWidget', () {
    const expectedFeatures = [
      'Sales',
      'Purchases',
      'Suppliers',
      'Clients',
      'Products',
      'Treasury',
    ];

    testWidgets('renders all feature tiles', (tester) async {
      await pumpWithApp(tester, _sheet());

      for (final feature in expectedFeatures) {
        expect(find.text(feature), findsOneWidget, reason: feature);
      }
    });

    testWidgets('renders the analysis widget', (tester) async {
      await pumpWithApp(tester, _sheet());

      expect(find.text('Analysis'), findsOneWidget);
    });

    testWidgets('shows a zero total on every tile', (tester) async {
      await pumpWithApp(tester, _sheet());

      expect(find.text('0'), findsNWidgets(expectedFeatures.length));
    });

    testWidgets('fires the callback when Products is tapped', (tester) async {
      var tapped = false;
      await pumpWithApp(
        tester,
        _sheet(onProductsTap: () => tapped = true),
      );

      await tester.tap(find.text('Products'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('fires the callback when Suppliers is tapped', (tester) async {
      var tapped = false;
      await pumpWithApp(
        tester,
        _sheet(onSuppliersTap: () => tapped = true),
      );

      await tester.tap(find.text('Suppliers'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('fires the callback when Clients is tapped', (tester) async {
      var tapped = false;
      await pumpWithApp(
        tester,
        _sheet(onClientsTap: () => tapped = true),
      );

      await tester.tap(find.text('Clients'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('fires the callback when Sales is tapped', (tester) async {
      var tapped = false;
      await pumpWithApp(
        tester,
        _sheet(onSalesTap: () => tapped = true),
      );

      await tester.tap(find.text('Sales'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('fires the callback when Purchases is tapped', (tester) async {
      var tapped = false;
      await pumpWithApp(
        tester,
        _sheet(onPurchasesTap: () => tapped = true),
      );

      await tester.tap(find.text('Purchases'));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}

DashBoardSheetWidget _sheet({
  VoidCallback onProductsTap = _noop,
  VoidCallback onSuppliersTap = _noop,
  VoidCallback onClientsTap = _noop,
  VoidCallback onSalesTap = _noop,
  VoidCallback onPurchasesTap = _noop,
}) {
  return DashBoardSheetWidget(
    onProductsTap: onProductsTap,
    onSuppliersTap: onSuppliersTap,
    onClientsTap: onClientsTap,
    onSalesTap: onSalesTap,
    onPurchasesTap: onPurchasesTap,
  );
}

void _noop() {}
