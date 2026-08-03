import 'package:flutter_test/flutter_test.dart';
import 'package:trucky/presentation/widgets/dashboard_sheet_widget.dart';

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
      await pumpWithApp(tester, const DashBoardSheetWidget());

      for (final feature in expectedFeatures) {
        expect(find.text(feature), findsOneWidget, reason: feature);
      }
    });

    testWidgets('renders the analysis widget', (tester) async {
      await pumpWithApp(tester, const DashBoardSheetWidget());

      expect(find.text('Analysis'), findsOneWidget);
    });

    testWidgets('shows a zero total on every tile', (tester) async {
      await pumpWithApp(tester, const DashBoardSheetWidget());

      expect(find.text('0'), findsNWidgets(expectedFeatures.length));
    });
  });
}
