import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trucky/core/constants/enums.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_event.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_models.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_state.dart';

/// Holds clients/suppliers state and exposes mutations for the UI.
class ClientSuppBloc extends Bloc<ClientSuppEvent, ClientSuppState> {
  ClientSuppBloc() : super(const ClientSuppState()) {
    on<LoadClientSuppEvent>(_onLoad);
    on<SetEntityTypeEvent>(_onSetEntityType);
    on<ToggleHomeBalanceVisibilityEvent>(_onToggleHomeBalance);
    on<ToggleSearchFieldEvent>(_onToggleSearchField);
    on<SearchClientSuppEvent>(_onSearch);
    on<SortClientSuppEvent>(_onSort);
    on<SelectClientSuppEvent>(_onSelect);
    on<AddClientSuppEvent>(_onAdd);
    on<FilterTxnsByPaymentTypeEvent>(_onFilterTxns);
  }

  int _nextClientId = 1;
  int _nextSupplierId = 1;
  int _nextTxnId = 1;

  void _onLoad(LoadClientSuppEvent event, Emitter<ClientSuppState> emit) {
    final now = DateTime.now();

    final clients = List<ClientSuppEntity>.generate(
      4,
      (index) => ClientSuppEntity(
        id: _nextClientId++,
        name: _clientNames[index],
        role: EntityType.client.name,
        phoneNumber: '055${1000000 + index * 111111}',
        gpsLocation: '36.710382, 3.199882',
        createdAt: now.subtract(Duration(days: index * 3)),
        updatedAt: now.subtract(Duration(days: index)),
      ),
    );

    final suppliers = List<ClientSuppEntity>.generate(
      3,
      (index) => ClientSuppEntity(
        id: _nextSupplierId++,
        name: _supplierNames[index],
        role: EntityType.supplier.name,
        phoneNumber: '077${2000000 + index * 222222}',
        gpsLocation: '36.7525, 3.0420',
        createdAt: now.subtract(Duration(days: index * 2)),
        updatedAt: now.subtract(Duration(days: index)),
      ),
    );

    final transactions = <ClientSuppTxn>[
      _buildTxn(
        clientSuppId: clients[0].id!,
        name: clients[0].name,
        amount: '1200',
        paymentType: 'Initial Balance',
        daysAgo: 10,
        role: EntityType.client.name,
      ),
      _buildTxn(
        clientSuppId: clients[1].id!,
        name: clients[1].name,
        amount: '800',
        paymentType: 'Initial Balance',
        daysAgo: 8,
        role: EntityType.client.name,
      ),
      _buildTxn(
        clientSuppId: suppliers[0].id!,
        name: suppliers[0].name,
        amount: '2000',
        paymentType: 'Initial Balance',
        daysAgo: 9,
        role: EntityType.supplier.name,
      ),
      _buildTxn(
        clientSuppId: clients[0].id!,
        name: clients[0].name,
        amount: '300',
        paymentType: 'Payment',
        daysAgo: 2,
        role: EntityType.client.name,
      ),
      _buildTxn(
        clientSuppId: suppliers[1].id!,
        name: suppliers[1].name,
        amount: '500',
        paymentType: 'Initial Balance',
        daysAgo: 6,
        role: EntityType.supplier.name,
      ),
    ];

    final clientTxns = transactions
        .where((t) => t.role == EntityType.client.name)
        .toList();
    final supplierTxns = transactions
        .where((t) => t.role == EntityType.supplier.name)
        .toList();

    emit(
      state.copyWith(
        entityType: event.entityType,
        clients: clients,
        suppliers: suppliers,
        allTransactions: transactions,
        clientTxns: clientTxns,
        supplierTxns: supplierTxns,
        selectedCSTxns: const [],
        homeBalance: _calcHomeBalance(
          clients,
          suppliers,
          clientTxns,
          supplierTxns,
          event.entityType,
        ),
      ),
    );
  }

  void _onSetEntityType(SetEntityTypeEvent event, Emitter<ClientSuppState> emit) {
    emit(
      state.copyWith(
        entityType: event.entityType,
        selectedCS: null,
        selectedCSTxns: const [],
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
    emit(state.copyWith(showSearchField: event.isVisible));
  }

  void _onSearch(SearchClientSuppEvent event, Emitter<ClientSuppState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onSort(SortClientSuppEvent event, Emitter<ClientSuppState> emit) {
    final sortType = SortType.values[event.index];
    final sorted = _applySort(List.from(state.currentEntityList), sortType);

    final clients =
        state.entityType == EntityType.client ? sorted : state.clients;
    final suppliers =
        state.entityType == EntityType.supplier ? sorted : state.suppliers;

    emit(
      state.copyWith(
        clients: clients,
        suppliers: suppliers,
        sortType: sortType,
      ),
    );
  }

  void _onSelect(SelectClientSuppEvent event, Emitter<ClientSuppState> emit) {
    if (event.index < 0 || event.index >= state.currentEntityList.length) return;
    final selected = state.currentEntityList[event.index];

    final txns = state.currentTxnList
        .where((t) => t.clientSuppId == selected.id)
        .toList();

    emit(
      state.copyWith(
        selectedCS: selected,
        selectedCSTxns: txns,
        selectedIndex: 0,
      ),
    );
  }

  void _onAdd(AddClientSuppEvent event, Emitter<ClientSuppState> emit) {
    final name = event.name.trim();
    if (name.isEmpty) {
      emit(state.copyWith(isNameRequired: true));
      return;
    }
    emit(state.copyWith(isNameRequired: false));

    final now = DateTime.now();
    final isClient = state.entityType == EntityType.client;

    final entity = ClientSuppEntity(
      id: isClient ? _nextClientId++ : _nextSupplierId++,
      name: name,
      role: state.entityType.name,
      phoneNumber: event.phoneNumber,
      gpsLocation: event.gpsLocation,
      createdAt: now,
      updatedAt: now,
    );

    final initialTxn = ClientSuppTxn(
      id: _nextTxnId++,
      clientSuppId: entity.id!,
      transactionId: 'txn-${now.microsecondsSinceEpoch}',
      clientSupplierName: name,
      role: state.entityType.name,
      txnData: now,
      amount: event.initialBalance.isEmpty ? '0' : event.initialBalance,
      paymentType: 'Initial Balance',
    );

    final allTxns = [...state.allTransactions, initialTxn];
    final clients = isClient ? [...state.clients, entity] : state.clients;
    final suppliers = isClient ? state.suppliers : [...state.suppliers, entity];
    final clientTxns =
        isClient ? [...state.clientTxns, initialTxn] : state.clientTxns;
    final supplierTxns =
        isClient ? state.supplierTxns : [...state.supplierTxns, initialTxn];

    emit(
      state.copyWith(
        clients: clients,
        suppliers: suppliers,
        allTransactions: allTxns,
        clientTxns: clientTxns,
        supplierTxns: supplierTxns,
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

  void _onFilterTxns(
    FilterTxnsByPaymentTypeEvent event,
    Emitter<ClientSuppState> emit,
  ) {
    final selected = state.selectedCS;
    if (selected == null) return;

    final paymentType = PaymentType.values[event.index];
    final all = state.currentTxnList
        .where((t) => t.clientSuppId == selected.id)
        .toList();

    final filtered = paymentType == PaymentType.all
        ? all
        : all.where((t) => _matchesPaymentType(t, paymentType)).toList();

    emit(
      state.copyWith(
        selectedCSTxns: filtered,
        selectedIndex: event.index,
      ),
    );
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

  ClientSuppTxn _buildTxn({
    required int clientSuppId,
    required String name,
    required String amount,
    required String paymentType,
    required int daysAgo,
    required String role,
  }) {
    return ClientSuppTxn(
      id: _nextTxnId++,
      clientSuppId: clientSuppId,
      transactionId: 'txn-$_nextTxnId',
      clientSupplierName: name,
      role: role,
      txnData: DateTime.now().subtract(Duration(days: daysAgo)),
      amount: amount,
      paymentType: paymentType,
    );
  }

  List<ClientSuppEntity> _applySort(
    List<ClientSuppEntity> list,
    SortType sortType,
  ) {
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
    List<ClientSuppEntity> clients,
    List<ClientSuppEntity> suppliers,
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

  static const List<String> _clientNames = [
    'Ahmed Benali',
    'Sara Haddad',
    'Karim Meziane',
    'Lina Bouzid',
  ];

  static const List<String> _supplierNames = [
    'Global Traders',
    'Algeria Auto Parts',
    'Mediterranean Supply',
  ];
}

/// Helper to compute an entity balance within the current bloc state.
class ClientSuppEntityBalance {
  static double getBalance(ClientSuppEntity entity, ClientSuppState state) {
    return ClientSuppTxn.calculateCurrentBalance(
      clientSupplierId: entity.id ?? -1,
      allTransactions: state.currentTxnList,
    );
  }
}
