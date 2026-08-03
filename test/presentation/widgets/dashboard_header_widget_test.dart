import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trucky/presentation/home/widgets/dashboard_header_widget.dart';

import '../../helpers/widget_harness.dart';

void main() {
  group('HomeHeaderWidget', () {
    testWidgets('renders the greeting and demo label', (tester) async {
      await pumpWithApp(
        tester,
        const HomeHeaderWidget(settingOnTap: _noop),
      );

      expect(find.text('Hello, User'), findsOneWidget);
      expect(find.text('Demo Version'), findsOneWidget);
    });

    testWidgets('shows the avatar and settings images', (tester) async {
      await pumpWithApp(
        tester,
        const HomeHeaderWidget(settingOnTap: _noop),
      );

      expect(find.byType(Image), findsNWidgets(2));
    });

    testWidgets('fires the callback when settings is tapped', (tester) async {
      var tapped = false;
      await pumpWithApp(
        tester,
        HomeHeaderWidget(settingOnTap: () => tapped = true),
      );

      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}

void _noop() {}
