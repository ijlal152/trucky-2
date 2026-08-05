/// Events accepted by [TreasuryBloc].
sealed class TreasuryEvent {
  const TreasuryEvent();
}

/// Loads the sample treasury entries and initial balance.
class LoadTreasuryEvent extends TreasuryEvent {
  const LoadTreasuryEvent();
}

/// Toggles the visibility of the total balance.
class ToggleBalanceVisibilityEvent extends TreasuryEvent {
  const ToggleBalanceVisibilityEvent();
}

/// Records a new cash inflow (payment received from a client).
class AddPaymentEvent extends TreasuryEvent {
  const AddPaymentEvent({
    required this.client,
    required this.date,
    required this.time,
    required this.amount,
    this.note,
  });

  final String client;
  final String date;
  final String time;
  final String amount;
  final String? note;
}