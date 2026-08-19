import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_bloc.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_event.dart';

import '../../../helpers/client_supp_test_harness.dart';
import '../../../helpers/fake_client_supp_repository.dart';

void main() {
  group('ClientSuppDashboardScreen', () {
    /// Pumps the clients list and navigates to Ahmed Benali's dashboard,
    /// mirroring real navigation so pop() has a route to return to.
    Future<void> pumpToDashboard(WidgetTester tester,
        {ClientSuppBloc? bloc}) async {
      final b = bloc ?? buildClientSuppBloc();
      b.add(const LoadClientSuppEvent());
      await tester.pump();

      await pumpRouterWithClientSuppApp(tester, bloc: b);

      await tester.tap(find.text('Ahmed Benali'));
      await tester.pumpAndSettle();
    }

    testWidgets('renders the selected client, balance and transactions',
        (tester) async {
      await pumpToDashboard(tester);

      expect(find.text('Ahmed Benali'), findsOneWidget);
      expect(find.text('Balance'), findsOneWidget);
      expect(find.text('Initial Balance'), findsOneWidget);
      expect(find.text('Payment'), findsOneWidget);
      // Dashboard total = 1200 initial - 300 payment = 900 (rendered in a
      // Text.rich). The same amount also appears as a running-balance row.
      expect(find.textContaining('900.00'), findsNWidgets(2));
      // Transaction row amounts.
      expect(find.text('1,200.00'), findsOneWidget);
      expect(find.text('300.00'), findsOneWidget);
    });

    testWidgets('filters transactions by payment type', (tester) async {
      await pumpToDashboard(tester);

      await tester.tap(find.text('Payments'));
      await tester.pumpAndSettle();

      expect(find.text('Payment'), findsOneWidget);
      expect(find.text('Initial Balance'), findsNothing);

      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();

      expect(find.text('Initial Balance'), findsOneWidget);
      expect(find.text('Payment'), findsOneWidget);
    });

    testWidgets('shows "No Record Found" when a filter has no transactions',
        (tester) async {
      await pumpToDashboard(tester);

      await tester.tap(find.text('Sales'));
      await tester.pumpAndSettle();

      expect(find.text('No Record Found'), findsOneWidget);
    });

    testWidgets('popup menu offers Edit and Delete', (tester) async {
      await pumpToDashboard(tester);

      await tester.tap(find.byType(PopupMenuButton<int>));
      await tester.pumpAndSettle();

      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('tapping Initial Balance does not navigate', (tester) async {
      await pumpToDashboard(tester);

      await tester.tap(find.text('Initial Balance'));
      await tester.pumpAndSettle();

      expect(find.text('Ahmed Benali'), findsOneWidget);
      expect(find.text('Balance'), findsOneWidget);
    });

    testWidgets('tapping a Payment transaction opens the payment details',
        (tester) async {
      await pumpToDashboard(tester);

      await tester.tap(find.text('Payment'));
      await tester.pumpAndSettle();

      expect(find.text('Payment Details'), findsOneWidget);
    });
  });
}
