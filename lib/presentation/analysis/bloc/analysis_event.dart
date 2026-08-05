/// Events accepted by [AnalysisBloc].
sealed class AnalysisEvent {
  const AnalysisEvent();
}

/// Loads the analysis metrics (sales/purchases totals) and default range.
class LoadAnalysisEvent extends AnalysisEvent {
  const LoadAnalysisEvent({
    required this.saleAmount,
    required this.purchaseAmount,
  });

  final double saleAmount;
  final double purchaseAmount;
}

/// Selects a time-range option by its index (Day/Week/Month/Year/Period).
class SelectRangeIndexEvent extends AnalysisEvent {
  const SelectRangeIndexEvent({required this.index});

  final int index;
}

/// Moves the current date one range backward.
class GoToPreviousEvent extends AnalysisEvent {
  const GoToPreviousEvent();
}

/// Moves the current date one range forward.
class GoToNextEvent extends AnalysisEvent {
  const GoToNextEvent();
}