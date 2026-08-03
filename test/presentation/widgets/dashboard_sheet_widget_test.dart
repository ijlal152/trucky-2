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
      await pumpWithApp(tester, const DashBoardSheetWidget(onProductsTap: _noop));

      for (final feature in expectedFeatures) {
        expect(find.text(feature), findsOneWidget, reason: feature);
      }
    });

    testWidgets('renders the analysis widget', (tester) async {
      await pumpWithApp(tester, const DashBoardSheetWidget(onProductsTap: _noop));

      expect(find.text('Analysis'), findsOneWidget);
    });

    testWidgets('shows a zero total on every tile', (tester) async {
      await pumpWithApp(tester, const DashBoardSheetWidget(onProductsTap: _noop));

      expect(find.text('0'), findsNWidgets(expectedFeatures.length));
    });

    testWidgets('fires the callback when Products is tapped', (tester) async {
      var tapped = false;
      await pumpWithApp(
        tester,
        DashBoardSheetWidget(onProductsTap: () => tapped = true),
      );

      await tester.tap(find.text('Products'));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}

void _noop() {}
