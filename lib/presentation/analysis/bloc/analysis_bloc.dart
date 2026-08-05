import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trucky/presentation/analysis/bloc/analysis_event.dart';
import 'package:trucky/presentation/analysis/bloc/analysis_state.dart';

/// Holds the analysis screen's range selection and computed metrics.
class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  AnalysisBloc() : super(AnalysisState()) {
    on<LoadAnalysisEvent>(_onLoad);
    on<SelectRangeIndexEvent>(_onSelectRange);
    on<GoToPreviousEvent>(_onPrevious);
    on<GoToNextEvent>(_onNext);
  }

  void _onLoad(LoadAnalysisEvent event, Emitter<AnalysisState> emit) {
    emit(
      state.copyWith(
        saleAmount: event.saleAmount,
        purchaseAmount: event.purchaseAmount,
      ),
    );
  }

  void _onSelectRange(
    SelectRangeIndexEvent event,
    Emitter<AnalysisState> emit,
  ) {
    emit(state.copyWith(selectedIndex: event.index));
  }

  void _onPrevious(GoToPreviousEvent event, Emitter<AnalysisState> emit) {
    emit(state.goToPrevious());
  }

  void _onNext(GoToNextEvent event, Emitter<AnalysisState> emit) {
    emit(state.goToNext());
  }
}