import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_bloc.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_event.dart';

import '../../../helpers/client_supp_test_harness.dart';
import '../../../helpers/fake_client_supp_repository.dart';

void main() {
  group('AddClientSuppScreen', () {
    final addButton = find.widgetWithText(ElevatedButton, 'Add Client');

    /// Pumps the clients list, then opens the Add screen via the FAB so a
    /// successful add can pop back to a real route.
    Future<void> pumpToAddScreen(WidgetTester tester,
        {ClientSuppBloc? bloc}) async {
      final b = bloc ?? buildClientSuppBloc();
      b.add(const LoadClientSuppEvent());
      await tester.pump();

      await pumpRouterWithClientSuppApp(tester, bloc: b);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
    }

    testWidgets('shows a validation error when the name is empty',
        (tester) async {
      await pumpToAddScreen(tester);

      await tester.tap(addButton);
      await tester.pumpAndSettle();

      expect(find.text('* Client name is required'), findsOneWidget);
    });

    testWidgets('adds a client when the form is valid', (tester) async {
      final bloc = buildClientSuppBloc();
      await pumpToAddScreen(tester, bloc: bloc);

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'New Client');
      await tester.enterText(fields.at(1), '0559999999');
      await tester.enterText(fields.at(3), '500');

      await tester.tap(addButton);
      await tester.pumpAndSettle();

      expect(bloc.state.clients.length, 5);
      final added = bloc.state.clients.last;
      expect(added.name, 'New Client');
      expect(added.phoneNumber, '0559999999');
      // An "Initial Balance" transaction is created for the new client.
      expect(bloc.state.allTransactions.length, 6);
    });

    testWidgets('does not add a client with a duplicate name',
        (tester) async {
      final bloc = buildClientSuppBloc();
      await pumpToAddScreen(tester, bloc: bloc);

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Ahmed Benali');
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      expect(bloc.state.clients.length, 4);
    });
  });
}
