import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/presentation/treasury/bloc/treasury_event.dart';
import 'package:trucky/presentation/treasury/bloc/treasury_models.dart';
import 'package:trucky/presentation/treasury/bloc/treasury_state.dart';

/// Holds the treasury cash-flow list and total balance.
class TreasuryBloc extends Bloc<TreasuryEvent, TreasuryState> {
  TreasuryBloc() : super(const TreasuryState()) {
    on<LoadTreasuryEvent>(_onLoad);
    on<ToggleBalanceVisibilityEvent>(_onToggleBalance);
    on<AddPaymentEvent>(_onAddPayment);
  }

  void _onLoad(LoadTreasuryEvent event, Emitter<TreasuryState> emit) {
    emit(
      TreasuryState(
        treasuryList: _sampleTreasuryList,
        totalBalance: 39520000,
      ),
    );
  }

  void _onToggleBalance(
    ToggleBalanceVisibilityEvent event,
    Emitter<TreasuryState> emit,
  ) {
    emit(state.copyWith(isBalanceVisible: !state.isBalanceVisible));
  }

  void _onAddPayment(AddPaymentEvent event, Emitter<TreasuryState> emit) {
    final client = event.client.trim();
    final amount = event.amount.trim();

    if (client.isEmpty) {
      emit(state.copyWith(isClientRequired: true));
      return;
    }
    if (amount.isEmpty) {
      emit(state.copyWith(isAmountRequired: true));
      return;
    }

    final parsedAmount = double.tryParse(amount) ?? 0.0;

    emit(
      state.copyWith(
        isClientRequired: false,
        isAmountRequired: false,
        treasuryList: [
          TreasuryModel(
            img: AppAssets.images.paymentIcon,
            name: client,
            date: event.date,
            time: event.time,
            amount: amount,
            status: '+Payment',
          ),
          ...state.treasuryList,
        ],
        totalBalance: state.totalBalance + parsedAmount,
      ),
    );
  }

  static final List<TreasuryModel> _sampleTreasuryList = [
    TreasuryModel(
      img: AppAssets.images.negativeRefundIcon,
      name: 'Client Name 1',
      date: '22/03/2023',
      time: '15:00',
      amount: '-100000',
      status: '-Refund',
    ),
    TreasuryModel(
      img: AppAssets.images.negativePaymentIcon,
      name: 'Supplier Name 1',
      date: '02/01/2023',
      time: '15:00',
      amount: '-47700',
      status: '-Payment',
    ),
    TreasuryModel(
      img: AppAssets.images.expenseIcon,
      name: 'Gasoil',
      date: '22/03/2023',
      time: '15:00',
      amount: '-1500',
      status: '-Expense',
    ),
    TreasuryModel(
      img: AppAssets.images.positiveRefundIcon,
      name: 'Supplier Name 1',
      date: '22/03/2023',
      time: '15:00',
      amount: '+1500',
      status: '+Refund',
    ),
    TreasuryModel(
      img: AppAssets.images.paymentIcon,
      name: 'Client Name 1',
      date: '22/03/2023',
      time: '15:00',
      amount: '+2500000',
      status: '+Payment',
    ),
  ];
}