import 'package:flutter_test/flutter_test.dart';
import 'package:trucky/core/constants/enums.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_bloc.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_event.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_models.dart';

import '../../../helpers/fake_client_supp_repository.dart';

/// Flushes the bloc's microtask queue so synchronous handlers complete.
Future<void> pumpEventQueue() async {
  for (var i = 0; i < 10; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ClientSuppBloc', () {
    late ClientSuppBloc bloc;

    setUp(() {
      bloc = buildClientSuppBloc();
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state defaults to the client tab', () {
      expect(bloc.state.entityType, EntityType.client);
      expect(bloc.state.clients, isEmpty);
      expect(bloc.state.suppliers, isEmpty);
      expect(bloc.state.homeBalance, 0);
      expect(bloc.state.isHomeBalanceVisible, isTrue);
    });

    group('LoadClientSuppEvent', () {
      test('seeds clients, suppliers and transactions', () async {
        bloc.add(const LoadClientSuppEvent());
        await pumpEventQueue();

        expect(bloc.state.clients.length, 4);
        expect(bloc.state.suppliers.length, 3);
        expect(bloc.state.allTransactions.length, 5);
        expect(bloc.state.clientTxns.length, 3);
        expect(bloc.state.supplierTxns.length, 2);
        expect(bloc.state.clients.first.name, 'Ahmed Benali');
        expect(bloc.state.suppliers.first.name, 'Global Traders');
      });

      test('computes the client home balance (900 + 800 = 1700)', () async {
        bloc.add(const LoadClientSuppEvent());
        await pumpEventQueue();

        expect(bloc.state.homeBalance, closeTo(1700.0, 0.001));
      });

      test('computes the supplier home balance (2000 + 500 = 2500)', () async {
        bloc.add(const LoadClientSuppEvent());
        await pumpEventQueue();

        bloc.add(const SetEntityTypeEvent(entityType: EntityType.supplier));
        await pumpEventQueue();

        expect(bloc.state.homeBalance, closeTo(2500.0, 0.001));
      });

      test('preserves the active entity type set before loading', () async {
        bloc.add(const SetEntityTypeEvent(entityType: EntityType.supplier));
        await pumpEventQueue();
        bloc.add(const LoadClientSuppEvent());
        await pumpEventQueue();

        // Opening the Suppliers tab must not reset the tab back to clients.
        expect(bloc.state.entityType, EntityType.supplier);
        expect(bloc.state.suppliers, isNotEmpty);
      });
    });

    group('SetEntityTypeEvent', () {
      test('switches lists and clears any selected entity', () async {
        bloc.add(const LoadClientSuppEvent());
        await pumpEventQueue();
        bloc.add(const SelectClientSuppEvent(index: 0));
        await pumpEventQueue();
        expect(bloc.state.selectedCS, isNotNull);

        bloc.add(const SetEntityTypeEvent(entityType: EntityType.supplier));
        await pumpEventQueue();

        expect(bloc.state.entityType, EntityType.supplier);
        expect(bloc.state.selectedCS, isNull);
        expect(bloc.state.selectedCSTxns, isEmpty);
      });
    });

    group('Search', () {
      test('filters entities by name and phone', () async {
        bloc.add(const LoadClientSuppEvent());
        await pumpEventQueue();

        bloc.add(const SearchClientSuppEvent(query: 'sara'));
        await pumpEventQueue();

        expect(bloc.state.searchResults.length, 1);
        expect(bloc.state.searchResults.first.name, 'Sara Haddad');
      });

      test('closing the search field clears the stale query', () async {
        bloc.add(const LoadClientSuppEvent());
        await pumpEventQueue();
        bloc.add(const SearchClientSuppEvent(query: 'sara'));
        await pumpEventQueue();
        expect(bloc.state.searchResults.length, 1);

        bloc.add(const ToggleSearchFieldEvent(isVisible: false));
        await pumpEventQueue();

        expect(bloc.state.searchQuery, isEmpty);
        expect(bloc.state.searchResults.length, 4);
      });
    });

    group('SortClientSuppEvent', () {
      test('sorts ascending by name', () async {
        bloc.add(const LoadClientSuppEvent());
        await pumpEventQueue();

        bloc.add(SortClientSuppEvent(index: SortType.ascending.index));
        await pumpEventQueue();

        expect(bloc.state.clients.map((c) => c.name).toList(), [
          'Ahmed Benali',
          'Karim Meziane',
          'Lina Bouzid',
          'Sara Haddad',
        ]);
      });

      test('sorts by balance high to low', () async {
        bloc.add(const LoadClientSuppEvent());
        await pumpEventQueue();

        bloc.add(SortClientSuppEvent(index: SortType.highToLow.index));
        await pumpEventQueue();

        expect(bloc.state.clients.first.name, 'Ahmed Benali');
        expect(bloc.state.clients[1].name, 'Sara Haddad');
      });
    });

    group('SelectClientSuppEvent', () {
      test('sets the selected entity and its transactions', () async {
        bloc.add(const LoadClientSuppEvent());
        await pumpEventQueue();

        bloc.add(const SelectClientSuppEvent(index: 0));
        await pumpEventQueue();

        expect(bloc.state.selectedCS?.name, 'Ahmed Benali');
        expect(bloc.state.selectedCSTxns.length, 2);
      });

      test('resolves the tap index against search results', () async {
        bloc.add(const LoadClientSuppEvent());
        await pumpEventQueue();
        bloc.add(const SearchClientSuppEvent(query: 'sara'));
        await pumpEventQueue();

        // "Sara Haddad" is the first result, not the first client.
        bloc.add(const SelectClientSuppEvent(index: 0));
        await pumpEventQueue();

        expect(bloc.state.selectedCS?.name, 'Sara Haddad');
        expect(bloc.state.selectedCSTxns.single.clientSuppId, 2);
      });

      test('ignores an out-of-range index', () async {
        bloc.add(const LoadClientSuppEvent());
        await pumpEventQueue();

        bloc.add(const SelectClientSuppEvent(index: 99));
        await pumpEventQueue();

        expect(bloc.state.selectedCS, isNull);
      });
    });

    group('AddClientSuppEvent', () {
      test('adds a client with an initial balance transaction', () async {
        bloc.add(const LoadClientSuppEvent());
        await pumpEventQueue();

        bloc.add(
          const AddClientSuppEvent(
            name: 'New Client',
            phoneNumber: '0559999999',
            initialBalance: '500',
          ),
        );
        await pumpEventQueue();

        expect(bloc.state.clients.length, 5);
        expect(bloc.state.clients.last.name, 'New Client');
        expect(bloc.state.clientTxns.length, 4);
        expect(bloc.state.allTransactions.length, 6);
        expect(bloc.state.homeBalance, closeTo(2200.0, 0.001));
      });

      test('adds a supplier when the supplier tab is active', () async {
        bloc.add(const LoadClientSuppEvent());
        await pumpEventQueue();
        bloc.add(const SetEntityTypeEvent(entityType: EntityType.supplier));
        await pumpEventQueue();

        bloc.add(
          const AddClientSuppEvent(name: 'New Supplier', initialBalance: '500'),
        );
        await pumpEventQueue();

        expect(bloc.state.suppliers.length, 4);
        expect(bloc.state.clients.length, 4);
        expect(bloc.state.supplierTxns.length, 3);
      });

      test('flags the name as required when it is empty', () async {
        bloc.add(const LoadClientSuppEvent());
        await pumpEventQueue();

        bloc.add(const AddClientSuppEvent(name: ''));
        await pumpEventQueue();

        expect(bloc.state.isNameRequired, isTrue);
        expect(bloc.state.clients.length, 4);
      });

      test('rejects a duplicate name', () async {
        bloc.add(const LoadClientSuppEvent());
        await pumpEventQueue();

        bloc.add(const AddClientSuppEvent(name: 'Ahmed Benali'));
        await pumpEventQueue();

        expect(bloc.state.clients.length, 4);
      });
    });

    group('FilterTxnsByPaymentTypeEvent', () {
      test(
        'filters the selected entity transactions by payment type',
        () async {
          bloc.add(const LoadClientSuppEvent());
          await pumpEventQueue();
          bloc.add(const SelectClientSuppEvent(index: 0));
          await pumpEventQueue();

          bloc.add(
            FilterTxnsByPaymentTypeEvent(index: PaymentType.payment.index),
          );
          await pumpEventQueue();

          expect(bloc.state.selectedCSTxns.length, 1);
          expect(bloc.state.selectedCSTxns.single.paymentType, 'Payment');
          expect(bloc.state.selectedIndex, PaymentType.payment.index);
        },
      );

      test('restores all transactions when "All" is selected', () async {
        bloc.add(const LoadClientSuppEvent());
        await pumpEventQueue();
        bloc.add(const SelectClientSuppEvent(index: 0));
        await pumpEventQueue();
        bloc.add(
          FilterTxnsByPaymentTypeEvent(index: PaymentType.payment.index),
        );
        await pumpEventQueue();
        expect(bloc.state.selectedCSTxns.length, 1);

        bloc.add(FilterTxnsByPaymentTypeEvent(index: PaymentType.all.index));
        await pumpEventQueue();

        expect(bloc.state.selectedCSTxns.length, 2);
      });
    });

    group('Balance visibility toggle', () {
      test('toggles the home balance visibility', () async {
        bloc.add(const ToggleHomeBalanceVisibilityEvent());
        await pumpEventQueue();

        expect(bloc.state.isHomeBalanceVisible, isFalse);
      });
    });

    group('AddTransactionEvent', () {
      test('adding a txn for the selected entity updates selectedCSTxns', () async {
        bloc.add(const LoadClientSuppEvent());
        await pumpEventQueue();
        bloc.add(const SelectClientSuppEvent(index: 0));
        await pumpEventQueue();
        final before = bloc.state.selectedCSTxns.length;

        bloc.add(
          AddTransactionEvent(
            txn: ClientSuppTxn(
              clientSuppId: 1,
              transactionId: 'txn-new',
              clientSupplierName: 'Ahmed Benali',
              role: 'client',
              txnData: DateTime.now(),
              amount: '100',
              paymentType: 'Sale',
            ),
          ),
        );
        await pumpEventQueue();

        expect(bloc.state.selectedCSTxns.length, before + 1);
        expect(
          bloc.state.selectedCSTxns.any((t) => t.transactionId == 'txn-new'),
          isTrue,
        );
      });

      test('adding a txn for another entity leaves selectedCSTxns unchanged',
          () async {
        bloc.add(const LoadClientSuppEvent());
        await pumpEventQueue();
        bloc.add(const SelectClientSuppEvent(index: 0));
        await pumpEventQueue();
        final before = bloc.state.selectedCSTxns.length;

        bloc.add(
          AddTransactionEvent(
            txn: ClientSuppTxn(
              clientSuppId: 2,
              transactionId: 'txn-other',
              clientSupplierName: 'Sara Haddad',
              role: 'client',
              txnData: DateTime.now(),
              amount: '100',
              paymentType: 'Sale',
            ),
          ),
        );
        await pumpEventQueue();

        expect(bloc.state.selectedCSTxns.length, before);
      });
    });

    group('ClientSuppTxn', () {
      test('calculateCurrentBalance applies payment type rules', () {
        final txns = [
          ClientSuppTxn(
            id: 1,
            clientSuppId: 1,
            transactionId: 't1',
            clientSupplierName: 'X',
            role: 'client',
            txnData: DateTime(2024, 1, 1),
            amount: '1000',
            paymentType: 'Initial Balance',
          ),
          ClientSuppTxn(
            id: 2,
            clientSuppId: 1,
            transactionId: 't2',
            clientSupplierName: 'X',
            role: 'client',
            txnData: DateTime(2024, 1, 2),
            amount: '200',
            paymentType: 'Sale',
          ),
          ClientSuppTxn(
            id: 3,
            clientSuppId: 1,
            transactionId: 't3',
            clientSupplierName: 'X',
            role: 'client',
            txnData: DateTime(2024, 1, 3),
            amount: '300',
            paymentType: 'Payment',
          ),
        ];

        expect(
          ClientSuppTxn.calculateCurrentBalance(
            clientSupplierId: 1,
            allTransactions: txns,
          ),
          closeTo(900.0, 0.001),
        );
      });

      test('calculateBalanceAtIndex sums the running balance', () {
        // Transactions are expected newest-first.
        final txns = [
          ClientSuppTxn(
            id: 2,
            clientSuppId: 1,
            transactionId: 't2',
            clientSupplierName: 'X',
            role: 'client',
            txnData: DateTime(2024, 1, 2),
            amount: '300',
            paymentType: 'Payment',
          ),
          ClientSuppTxn(
            id: 1,
            clientSuppId: 1,
            transactionId: 't1',
            clientSupplierName: 'X',
            role: 'client',
            txnData: DateTime(2024, 1, 1),
            amount: '1000',
            paymentType: 'Initial Balance',
          ),
        ];

        // Full balance: 1000 initial - 300 payment = 700.
        expect(
          ClientSuppTxn.calculateBalanceAtIndex(transactions: txns, index: 0),
          closeTo(700.0, 0.001),
        );
        // Balance at the initial-balance transaction only.
        expect(
          ClientSuppTxn.calculateBalanceAtIndex(transactions: txns, index: 1),
          closeTo(1000.0, 0.001),
        );

        // runningBalances matches calculateBalanceAtIndex at every index.
        final balances = ClientSuppTxn.runningBalances(txns);
        expect(balances[0], closeTo(700.0, 0.001));
        expect(balances[1], closeTo(1000.0, 0.001));
      });

      test('selecting a client sorts its transactions newest-first', () async {
        bloc.add(const LoadClientSuppEvent());
        await pumpEventQueue();

        bloc.add(const SelectClientSuppEvent(index: 0));
        await pumpEventQueue();

        // Ahmed: Payment (2d ago) must appear before Initial (10d ago), and the
        // dashboard total (balance at index 0) equals the real balance of 900.
        expect(bloc.state.selectedCSTxns.first.paymentType, 'Payment');
        final dashboardTotal = ClientSuppTxn.calculateBalanceAtIndex(
          transactions: bloc.state.selectedCSTxns,
          index: 0,
        );
        expect(dashboardTotal, closeTo(900.0, 0.001));
      });

      test('sale sorts before its payment when timestamps tie', () async {
        bloc.add(const LoadClientSuppEvent());
        await pumpEventQueue();

        final sameInstant = DateTime.now();
        bloc.add(
          AddTransactionEvent(
            txn: ClientSuppTxn(
              clientSuppId: 1,
              transactionId: 'txn-tie',
              clientSupplierName: 'Ahmed Benali',
              role: 'client',
              txnData: sameInstant,
              amount: '200',
              paymentType: 'Sale',
            ),
          ),
        );
        bloc.add(
          AddTransactionEvent(
            txn: ClientSuppTxn(
              clientSuppId: 1,
              transactionId: 'txn-tie',
              clientSupplierName: 'Ahmed Benali',
              role: 'client',
              txnData: sameInstant,
              amount: '150',
              paymentType: 'Payment',
            ),
          ),
        );
        await pumpEventQueue();

        bloc.add(const SelectClientSuppEvent(index: 0));
        await pumpEventQueue();

        final types = bloc.state.selectedCSTxns
            .map((t) => t.paymentType)
            .toList();
        expect(types, ['Sale', 'Payment', 'Payment', 'Initial Balance']);
      });

      test('sale sorts before its payment even when timestamps drift', () async {
        bloc.add(const LoadClientSuppEvent());
        await pumpEventQueue();

        final saleInstant = DateTime.now();
        bloc.add(
          AddTransactionEvent(
            txn: ClientSuppTxn(
              clientSuppId: 1,
              transactionId: 'txn-drift',
              clientSupplierName: 'Ahmed Benali',
              role: 'client',
              txnData: saleInstant,
              amount: '200',
              paymentType: 'Sale',
            ),
          ),
        );
        bloc.add(
          AddTransactionEvent(
            txn: ClientSuppTxn(
              clientSuppId: 1,
              transactionId: 'txn-drift',
              clientSupplierName: 'Ahmed Benali',
              role: 'client',
              txnData: saleInstant.add(const Duration(microseconds: 5)),
              amount: '150',
              paymentType: 'Payment',
            ),
          ),
        );
        await pumpEventQueue();

        bloc.add(const SelectClientSuppEvent(index: 0));
        await pumpEventQueue();

        final types = bloc.state.selectedCSTxns
            .map((t) => t.paymentType)
            .toList();
        expect(types, ['Sale', 'Payment', 'Payment', 'Initial Balance']);
      });
    });
  });
}
