import 'package:trucky/core/constants/enums.dart';

/// Events accepted by [ClientSuppBloc].
sealed class ClientSuppEvent {
  const ClientSuppEvent();
}

/// Loads the initial (sample) clients/suppliers/transactions.
class LoadClientSuppEvent extends ClientSuppEvent {
  const LoadClientSuppEvent({this.entityType = EntityType.client});

  final EntityType entityType;
}

/// Sets which entity type is currently shown (clients or suppliers).
class SetEntityTypeEvent extends ClientSuppEvent {
  const SetEntityTypeEvent({required this.entityType});

  final EntityType entityType;
}

class ToggleHomeBalanceVisibilityEvent extends ClientSuppEvent {
  const ToggleHomeBalanceVisibilityEvent();
}

class ToggleSearchFieldEvent extends ClientSuppEvent {
  const ToggleSearchFieldEvent({required this.isVisible});

  final bool isVisible;
}

class SearchClientSuppEvent extends ClientSuppEvent {
  const SearchClientSuppEvent({required this.query});

  final String query;
}

class SortClientSuppEvent extends ClientSuppEvent {
  const SortClientSuppEvent({required this.index});

  final int index;
}

class SelectClientSuppEvent extends ClientSuppEvent {
  const SelectClientSuppEvent({required this.index});

  final int index;
}

class AddClientSuppEvent extends ClientSuppEvent {
  const AddClientSuppEvent({
    required this.name,
    this.phoneNumber = '',
    this.gpsLocation = '',
    this.initialBalance = '0',
  });

  final String name;
  final String phoneNumber;
  final String gpsLocation;
  final String initialBalance;
}

class FilterTxnsByPaymentTypeEvent extends ClientSuppEvent {
  const FilterTxnsByPaymentTypeEvent({required this.index});

  final int index;
}
