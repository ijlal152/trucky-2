import 'package:trucky/presentation/treasury/bloc/treasury_models.dart';

/// State exposed by [TreasuryBloc].
class TreasuryState {
  const TreasuryState({
    this.treasuryList = const [],
    this.totalBalance = 0,
    this.isBalanceVisible = true,
    this.isClientRequired = false,
    this.isAmountRequired = false,
  });

  final List<TreasuryModel> treasuryList;

  /// Raw running balance; format via [NumberFormater] before displaying.
  final double totalBalance;
  final bool isBalanceVisible;
  final bool isClientRequired;
  final bool isAmountRequired;

  TreasuryState copyWith({
    List<TreasuryModel>? treasuryList,
    double? totalBalance,
    bool? isBalanceVisible,
    bool? isClientRequired,
    bool? isAmountRequired,
  }) {
    return TreasuryState(
      treasuryList: treasuryList ?? this.treasuryList,
      totalBalance: totalBalance ?? this.totalBalance,
      isBalanceVisible: isBalanceVisible ?? this.isBalanceVisible,
      isClientRequired: isClientRequired ?? this.isClientRequired,
      isAmountRequired: isAmountRequired ?? this.isAmountRequired,
    );
  }
}