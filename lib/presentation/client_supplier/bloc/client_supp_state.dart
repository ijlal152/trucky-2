import 'package:trucky/core/constants/enums.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_models.dart';

/// State exposed by [ClientSuppBloc].
class ClientSuppState {
  const ClientSuppState({
    this.entityType = EntityType.client,
    this.clients = const [],
    this.suppliers = const [],
    this.allTransactions = const [],
    this.clientTxns = const [],
    this.supplierTxns = const [],
    this.selectedCSTxns = const [],
    this.selectedCS,
    this.selectedIndex = 0,
    this.sortType = SortType.oldestFirst,
    this.showSearchField = false,
    this.isHomeBalanceVisible = true,
    this.isNameRequired = false,
    this.searchQuery = '',
    this.homeBalance = 0,
  });

  final EntityType entityType;
  final List<ClientSuppEntity> clients;
  final List<ClientSuppEntity> suppliers;
  final List<ClientSuppTxn> allTransactions;

  /// Full transaction lists per entity type (used for balance calcs).
  final List<ClientSuppTxn> clientTxns;
  final List<ClientSuppTxn> supplierTxns;

  /// Transactions displayed for the selected client/supplier (dashboard).
  final List<ClientSuppTxn> selectedCSTxns;
  final ClientSuppEntity? selectedCS;
  final int selectedIndex;
  final SortType sortType;
  final bool showSearchField;
  final bool isHomeBalanceVisible;
  final bool isNameRequired;
  final String searchQuery;
  final double homeBalance;

  List<ClientSuppEntity> get currentEntityList =>
      entityType == EntityType.client ? clients : suppliers;

  /// Entities filtered by the active search query (name or phone).
  List<ClientSuppEntity> get searchResults {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) return currentEntityList;
    return currentEntityList.where((entity) {
      return entity.name.toLowerCase().contains(query) ||
          entity.phoneNumber.toLowerCase().contains(query);
    }).toList();
  }

  List<ClientSuppTxn> get currentTxnList =>
      entityType == EntityType.client ? clientTxns : supplierTxns;

  ClientSuppState copyWith({
    EntityType? entityType,
    List<ClientSuppEntity>? clients,
    List<ClientSuppEntity>? suppliers,
    List<ClientSuppTxn>? allTransactions,
    List<ClientSuppTxn>? clientTxns,
    List<ClientSuppTxn>? supplierTxns,
    List<ClientSuppTxn>? selectedCSTxns,
    ClientSuppEntity? selectedCS,
    int? selectedIndex,
    SortType? sortType,
    bool? showSearchField,
    bool? isHomeBalanceVisible,
    bool? isNameRequired,
    String? searchQuery,
    double? homeBalance,
    bool clearSelectedCS = false,
  }) {
    return ClientSuppState(
      entityType: entityType ?? this.entityType,
      clients: clients ?? this.clients,
      suppliers: suppliers ?? this.suppliers,
      allTransactions: allTransactions ?? this.allTransactions,
      clientTxns: clientTxns ?? this.clientTxns,
      supplierTxns: supplierTxns ?? this.supplierTxns,
      selectedCSTxns: selectedCSTxns ?? this.selectedCSTxns,
      selectedCS: clearSelectedCS ? null : (selectedCS ?? this.selectedCS),
      selectedIndex: selectedIndex ?? this.selectedIndex,
      sortType: sortType ?? this.sortType,
      showSearchField: showSearchField ?? this.showSearchField,
      isHomeBalanceVisible: isHomeBalanceVisible ?? this.isHomeBalanceVisible,
      isNameRequired: isNameRequired ?? this.isNameRequired,
      searchQuery: searchQuery ?? this.searchQuery,
      homeBalance: homeBalance ?? this.homeBalance,
    );
  }
}
