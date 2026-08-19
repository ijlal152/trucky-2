import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/constants/enums.dart';
import 'package:trucky/core/constants/route_paths.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_event.dart';

import '../../../helpers/client_supp_test_harness.dart';
import '../../../helpers/fake_client_supp_repository.dart';

Finder imageAsset(String assetName) {
  return find.byWidgetPredicate(
    (widget) =>
        widget is Image &&
        widget.image is AssetImage &&
        (widget.image as AssetImage).assetName == assetName,
  );
}

void main() {
  group('ClientSuppPage', () {
    testWidgets('loads and lists the sample clients', (tester) async {
      await pumpRouterWithClientSuppApp(tester);

      expect(find.text('Clients'), findsOneWidget);
      expect(find.text('Ahmed Benali'), findsOneWidget);
      expect(find.text('Sara Haddad'), findsOneWidget);
      expect(find.text('Karim Meziane'), findsOneWidget);
      expect(find.text('Lina Bouzid'), findsOneWidget);
      expect(find.text('Total Balance'), findsOneWidget);
    });

    testWidgets('loads suppliers when the supplier tab is active',
        (tester) async {
      final bloc = buildClientSuppBloc();
      bloc.add(const SetEntityTypeEvent(entityType: EntityType.supplier));
      await tester.pump();

      await pumpRouterWithClientSuppApp(
        tester,
        bloc: bloc,
        initialLocation: RoutePaths.suppliers,
      );

      expect(find.text('Suppliers'), findsOneWidget);
      expect(find.text('Global Traders'), findsOneWidget);
      expect(find.text('Algeria Auto Parts'), findsOneWidget);
      expect(find.text('Mediterranean Supply'), findsOneWidget);

      bloc.close();
    });

    testWidgets('reveals balances after tapping the visibility toggle',
        (tester) async {
      await pumpRouterWithClientSuppApp(tester);

      // Balances are obscured by default (the 4 list rows; the total balance
      // widget renders via Text.rich so it is not matched by find.text).
      expect(find.text('*******'), findsNWidgets(4));

      // Asset images resolve asynchronously (zero-width until loaded), so the
      // tiny toggle is un-tappable in isolation. Precache the icon to give it
      // its real size before tapping.
      await tester.runAsync(
        () => precacheImage(
          AssetImage(AppAssets.images.visibilityOn),
          tester.element(find.byType(MaterialApp)),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(imageAsset(AppAssets.images.visibilityOn),
          warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.text('900.00'), findsOneWidget); // Ahmed Benali
      expect(find.text('800.00'), findsOneWidget); // Sara Haddad
      expect(find.text('*******'), findsNothing);
    });

    testWidgets('filters the list when searching', (tester) async {
      await pumpRouterWithClientSuppApp(tester);

      await tester.tap(imageAsset(AppAssets.images.searchIcon),
          warnIfMissed: false);
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'sara');
      await tester.pumpAndSettle();

      expect(find.text('Sara Haddad'), findsOneWidget);
      expect(find.text('Ahmed Benali'), findsNothing);

      // Closing the search restores the full list.
      await tester.tap(find.byIcon(Icons.cancel_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Ahmed Benali'), findsOneWidget);
      expect(find.text('Sara Haddad'), findsOneWidget);
    });

    testWidgets('tapping a client navigates to the dashboard',
        (tester) async {
      await pumpRouterWithClientSuppApp(tester);

      await tester.tap(find.text('Ahmed Benali'));
      await tester.pumpAndSettle();

      expect(find.text('Balance'), findsOneWidget);
      expect(find.text('Initial Balance'), findsOneWidget);
      expect(find.text('Payment'), findsOneWidget);
    });
  });
}
