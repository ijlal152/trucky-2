import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trucky/core/constants/enums.dart';
import 'package:trucky/core/di/injector.dart';
import 'package:trucky/core/usecase/usecase.dart';
import 'package:trucky/domain/entities/client_supp_entity.dart';
import 'package:trucky/domain/entities/client_supp_txn_entity.dart';
import 'package:trucky/domain/usecases/add_client_supp_txn_usecase.dart';
import 'package:trucky/domain/usecases/add_client_supp_usecase.dart';
import 'package:trucky/domain/usecases/delete_client_supp_txn_usecase.dart';
import 'package:trucky/domain/usecases/fetch_all_client_supp_txn_usecase.dart';
import 'package:trucky/domain/usecases/fetch_all_client_supp_usecase.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_event.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_models.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_state.dart';
import 'package:trucky/presentation/widgets/custom_snackbar.dart';

/// Holds clients/suppliers state and exposes mutations for the UI.
///
/// All reads/writes are persisted to the local SQLite database through the
/// [ClientSuppRepository] use cases; the bloc keeps an in-memory projection
/// for the UI.
class ClientSuppBloc extends Bloc<ClientSuppEvent, ClientSuppState> {
  ClientSuppBloc({
    FetchAllClientSuppUsecase? fetchAllClientSupps,
    FetchAllClientSuppTxnUsecase? fetchAllClientSuppTxns,
    AddClientSuppUsecase? addClientSupp,
    AddClientSuppTxnUsecase? addClientSuppTxn,
    DeleteClientSuppTxnUsecase? deleteClientSuppTxn,
  }) : _fetchAllClientSupps =
           fetchAllClientSupps ?? Injector.fetchAllClientSuppUsecase,
       _fetchAllClientSuppTxns =
           fetchAllClientSuppTxns ?? Injector.fetchAllClientSuppTxnUsecase,
       _addClientSupp = addClientSupp ?? Injector.addClientSuppUsecase,
       _addClientSuppTxn = addClientSuppTxn ?? Injector.addClientSuppTxnUsecase,
       _deleteClientSuppTxn =
           deleteClientSuppTxn ?? Injector.deleteClientSuppTxnUsecase,
       super(const ClientSuppState()) {
    on<LoadClientSuppEvent>(_onLoad);
    on<SetEntityTypeEvent>(_onSetEntityType);
    on<ToggleHomeBalanceVisibilityEvent>(_onToggleHomeBalance);
    on<ToggleSearchFieldEvent>(_onToggleSearchField);
    on<SearchClientSuppEvent>(_onSearch);
    on<SortClientSuppEvent>(_onSort);
    on<SelectClientSuppEvent>(_onSelect);
    on<AddClientSuppEvent>(_onAdd);
    on<FilterTxnsByPaymentTypeEvent>(_onFilterTxns);
    on<AddTransactionEvent>(_onAddTransaction);
    on<RemoveTransactionsEvent>(_onRemoveTransactions);
  }

  final FetchAllClientSuppUsecase _fetchAllClientSupps;
  final FetchAllClientSuppTxnUsecase _fetchAllClientSuppTxns;
  final AddClientSuppUsecase _addClientSupp;
  final AddClientSuppTxnUsecase _addClientSuppTxn;
  final DeleteClientSuppTxnUsecase _deleteClientSuppTxn;

  /// No auth/user module exists yet; the schema requires a `user_id`.
  static const int _defaultUserId = 1;

  Future<void> _onLoad(
    LoadClientSuppEvent event,
    Emitter<ClientSuppState> emit,
  ) async {
    final entitiesResult = await _fetchAllClientSupps(const NoParams());
    final txnsResult = await _fetchAllClientSuppTxns(const NoParams());

    final entities = entitiesResult.when(
      success: (data) => data,
      failure: (_) => <ClientSuppEntity>[],
    );
    final txns = txnsResult.when(
      success: (data) => data,
      failure: (_) => <ClientSuppTxnEntity>[],
    );

    final clients = entities
        .where((e) => e.role == EntityType.client.name)
        .map(ClientSupp.fromEntity)
        .toList();
    final suppliers = entities
        .where((e) => e.role == EntityType.supplier.name)
        .map(ClientSupp.fromEntity)
        .toList();

    final allTransactions = txns.map(ClientSuppTxn.fromEntity).toList();
    final clientTxns = allTransactions
        .where((t) => t.role == EntityType.client.name)
        .toList();
    final supplierTxns = allTransactions
        .where((t) => t.role == EntityType.supplier.name)
        .toList();

    emit(
      state.copyWith(
        // Keep the caller's entity type (set from the home dashboard) rather
        // than resetting it to the event default of `client`.
        entityType: state.entityType,
        clients: clients,
        suppliers: suppliers,
        allTransactions: allTransactions,
        clientTxns: clientTxns,
        supplierTxns: supplierTxns,
        selectedCSTxns: const [],
        homeBalance: _calcHomeBalance(
          clients,
          suppliers,
          clientTxns,
          supplierTxns,
          state.entityType,
        ),
      ),
    );
  }

  void _onSetEntityType(
    SetEntityTypeEvent event,
    Emitter<ClientSuppState> emit,
  ) {
    emit(
      state.copyWith(
        entityType: event.entityType,
        selectedCSTxns: const [],
        clearSelectedCS: true,
        homeBalance: _calcHomeBalance(
          state.clients,
          state.suppliers,
          state.clientTxns,
          state.supplierTxns,
          event.entityType,
        ),
      ),
    );
  }

  void _onToggleHomeBalance(
    ToggleHomeBalanceVisibilityEvent event,
    Emitter<ClientSuppState> emit,
  ) {
    emit(state.copyWith(isHomeBalanceVisible: !state.isHomeBalanceVisible));
  }

  void _onToggleSearchField(
    ToggleSearchFieldEvent event,
    Emitter<ClientSuppState> emit,
  ) {
    emit(
      state.copyWith(
        showSearchField: event.isVisible,
        // Programmatic controller clears do not fire onChanged, so drop any
        // stale query when the field is closed.
        searchQuery: event.isVisible ? state.searchQuery : '',
      ),
    );
  }

  void _onSearch(SearchClientSuppEvent event, Emitter<ClientSuppState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onSort(SortClientSuppEvent event, Emitter<ClientSuppState> emit) {
    final sortType = SortType.values[event.index];
    final sorted = _applySort(List.from(state.currentEntityList), sortType);

    final clients = state.entityType == EntityType.client
        ? sorted
        : state.clients;
    final suppliers = state.entityType == EntityType.supplier
        ? sorted
        : state.suppliers;

    emit(
      state.copyWith(
        clients: clients,
        suppliers: suppliers,
        sortType: sortType,
      ),
    );
  }

  void _onSelect(SelectClientSuppEvent event, Emitter<ClientSuppState> emit) {
    // The list screen renders `searchResults` while a query is active, so the
    // tap index must be resolved against the same list.
    final list = state.searchQuery.trim().isNotEmpty
        ? state.searchResults
        : state.currentEntityList;
    if (event.index < 0 || event.index >= list.length) return;
    final selected = list[event.index];

    // Newest-first so running balances (calculateBalanceAtIndex) and the
    // dashboard total reflect the current balance.
    final txns = _sortTxnsNewestFirst(
      state.currentTxnList.where((t) => t.clientSuppId == selected.id),
    );

    emit(
      state.copyWith(
        selectedCS: selected,
        selectedCSTxns: txns,
        selectedIndex: 0,
      ),
    );
  }

  Future<void> _onAdd(
    AddClientSuppEvent event,
    Emitter<ClientSuppState> emit,
  ) async {
    final name = event.name.trim();
    if (name.isEmpty) {
      emit(state.copyWith(isNameRequired: true));
      return;
    }
    emit(state.copyWith(isNameRequired: false));

    final existing = state.entityType == EntityType.client
        ? state.clients
        : state.suppliers;
    final isDuplicate = existing.any(
      (e) => e.name.toLowerCase() == name.toLowerCase(),
    );
    if (isDuplicate) {
      MySnackbarMessage.showErrorMessage(
        title: 'Error!',
        message: 'Entity with this name already exists.',
      );
      return;
    }

    final now = DateTime.now();
    final entity = ClientSuppEntity(
      userId: _defaultUserId,
      name: name,
      role: state.entityType.name,
      phoneNumber: event.phoneNumber.isEmpty ? null : event.phoneNumber,
      gpsLocation: event.gpsLocation.isEmpty ? null : event.gpsLocation,
      createdAt: now,
      updatedAt: now,
    );

    final result = await _addClientSupp(entity);
    final id = result.when(
      success: (id) => id,
      failure: (e) {
        MySnackbarMessage.showErrorMessage(title: 'Error!', message: e.message);
        return -1;
      },
    );
    if (id < 0) return;

    final initialBalance = event.initialBalance.trim();
    if (initialBalance.isNotEmpty && double.tryParse(initialBalance) != 0) {
      final txn = ClientSuppTxnEntity(
        userId: _defaultUserId,
        clientSuppId: id,
        transactionId: 'txn-${now.microsecondsSinceEpoch}',
        clientSupplierName: name,
        role: state.entityType.name,
        txnData: now,
        amount: initialBalance,
        paymentType: 'Initial Balance',
      );
      await _addClientSuppTxn(txn);
    }
    await _onLoad(const LoadClientSuppEvent(), emit);
  }

  Future<void> _onAddTransaction(
    AddTransactionEvent event,
    Emitter<ClientSuppState> emit,
  ) async {
    final txn = event.txn;
    final entity = ClientSuppTxnEntity(
      userId: _defaultUserId,
      clientSuppId: txn.clientSuppId,
      transactionId: txn.transactionId,
      clientSupplierName: txn.clientSupplierName,
      role: txn.role,
      txnData: txn.txnData,
      discountAmount: txn.discountAmount,
      amount: txn.amount,
      paymentType: txn.paymentType,
      note: txn.note,
    );

    final result = await _addClientSuppTxn(entity);
    result.when(
      success: (id) {
        final persisted = txn.copyWith(id: id);
        final isClient = persisted.role == EntityType.client.name;
        final clientTxns = isClient
            ? [...state.clientTxns, persisted]
            : state.clientTxns;
        final supplierTxns = isClient
            ? state.supplierTxns
            : [...state.supplierTxns, persisted];

        emit(
          state.copyWith(
            allTransactions: [...state.allTransactions, persisted],
            clientTxns: clientTxns,
            supplierTxns: supplierTxns,
            homeBalance: _calcHomeBalance(
              state.clients,
              state.suppliers,
              clientTxns,
              supplierTxns,
              state.entityType,
            ),
          ),
        );
      },
      failure: (e) {
        MySnackbarMessage.showErrorMessage(title: 'Error!', message: e.message);
      },
    );
  }

  Future<void> _onRemoveTransactions(
    RemoveTransactionsEvent event,
    Emitter<ClientSuppState> emit,
  ) async {
    final toDelete = state.allTransactions
        .where((t) => t.transactionId == event.transactionId)
        .toList();
    for (final t in toDelete) {
      if (t.id != null) {
        await _deleteClientSuppTxn(t.id!);
      }
    }

    final remaining = state.allTransactions
        .where((t) => t.transactionId != event.transactionId)
        .toList();
    final clientTxns = remaining
        .where((t) => t.role == EntityType.client.name)
        .toList();
    final supplierTxns = remaining
        .where((t) => t.role == EntityType.supplier.name)
        .toList();

    emit(
      state.copyWith(
        allTransactions: remaining,
        clientTxns: clientTxns,
        supplierTxns: supplierTxns,
        selectedCSTxns: state.selectedCSTxns
            .where((t) => t.transactionId != event.transactionId)
            .toList(),
        homeBalance: _calcHomeBalance(
          state.clients,
          state.suppliers,
          clientTxns,
          supplierTxns,
          state.entityType,
        ),
      ),
    );
  }

  void _onFilterTxns(
    FilterTxnsByPaymentTypeEvent event,
    Emitter<ClientSuppState> emit,
  ) {
    final selected = state.selectedCS;
    if (selected == null) return;

    final paymentType = PaymentType.values[event.index];
    final all = _sortTxnsNewestFirst(
      state.currentTxnList.where((t) => t.clientSuppId == selected.id),
    );

    final filtered = paymentType == PaymentType.all
        ? all
        : all.where((t) => _matchesPaymentType(t, paymentType)).toList();

    emit(state.copyWith(selectedCSTxns: filtered, selectedIndex: event.index));
  }

  /// Sorts transactions newest-first, matching how the old app displayed
  /// them and how [ClientSuppTxn.calculateBalanceAtIndex] expects its input.
  List<ClientSuppTxn> _sortTxnsNewestFirst(
    Iterable<ClientSuppTxn> transactions,
  ) {
    final sorted = transactions.toList()
      ..sort((a, b) => b.txnData.compareTo(a.txnData));
    return sorted;
  }

  bool _matchesPaymentType(ClientSuppTxn txn, PaymentType type) {
    final label = txn.paymentType.toLowerCase();
    switch (type) {
      case PaymentType.all:
        return true;
      case PaymentType.sale:
        return label == 'sale';
      case PaymentType.payment:
        return label == 'payment';
      case PaymentType.returnn:
        return label == 'return';
      case PaymentType.refund:
        return label == 'refund';
      case PaymentType.purchase:
        return label == 'purchase';
    }
  }

  List<ClientSupp> _applySort(List<ClientSupp> list, SortType sortType) {
    switch (sortType) {
      case SortType.ascending:
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortType.descending:
        list.sort((a, b) => b.name.compareTo(a.name));
        break;
      case SortType.highToLow:
        list.sort((a, b) {
          final balanceA = ClientSuppEntityBalance.getBalance(a, state);
          final balanceB = ClientSuppEntityBalance.getBalance(b, state);
          return balanceB.compareTo(balanceA);
        });
        break;
      case SortType.lowToHigh:
        list.sort((a, b) {
          final balanceA = ClientSuppEntityBalance.getBalance(a, state);
          final balanceB = ClientSuppEntityBalance.getBalance(b, state);
          return balanceA.compareTo(balanceB);
        });
        break;
      case SortType.newestFirst:
        list.sort((a, b) {
          final dateA = a.updatedAt ?? a.createdAt;
          final dateB = b.updatedAt ?? b.createdAt;
          return dateB.compareTo(dateA);
        });
        break;
      case SortType.oldestFirst:
        list.sort((a, b) {
          final dateA = a.updatedAt ?? a.createdAt;
          final dateB = b.updatedAt ?? b.createdAt;
          return dateA.compareTo(dateB);
        });
        break;
      case SortType.none:
        break;
    }
    return list;
  }

  double _calcHomeBalance(
    List<ClientSupp> clients,
    List<ClientSupp> suppliers,
    List<ClientSuppTxn> clientTxns,
    List<ClientSuppTxn> supplierTxns,
    EntityType entityType,
  ) {
    final list = entityType == EntityType.client ? clients : suppliers;
    final txns = entityType == EntityType.client ? clientTxns : supplierTxns;

    return list.fold<double>(0, (sum, entity) {
      final balance = ClientSuppTxn.calculateCurrentBalance(
        clientSupplierId: entity.id ?? -1,
        allTransactions: txns,
      );
      return sum + balance;
    });
  }
}

/// Helper to compute an entity balance within the current bloc state.
class ClientSuppEntityBalance {
  static double getBalance(ClientSupp entity, ClientSuppState state) {
    return ClientSuppTxn.calculateCurrentBalance(
      clientSupplierId: entity.id ?? -1,
      allTransactions: state.currentTxnList,
    );
  }
}
