import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/constants/font_constants.dart';
import 'package:trucky/presentation/analysis/bloc/analysis_bloc.dart';
import 'package:trucky/presentation/analysis/bloc/analysis_event.dart';
import 'package:trucky/presentation/analysis/bloc/analysis_state.dart';
import 'package:trucky/presentation/analysis/widgets/expenses.dart';
import 'package:trucky/presentation/analysis/widgets/time_range_selector.dart';
import 'package:trucky/presentation/widgets/custom_decorated_container.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// Withdrawals section.
class Withdrawals extends StatelessWidget {
  const Withdrawals({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalysisBloc, AnalysisState>(
      builder: (context, state) {
        return DecoratedContainer(
          width: double.infinity,
          borderRadius: 16,
          margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 30.h),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LabelWidget(
                text: 'Withdrawals',
                textSize: 20.sp,
                textColor: Colors.black,
                fontWeight: FontWeight.w500,
                fontFamily: FontConstants.interSemiBold,
              ),
              SizedBox(height: 10.h),
              TimeRangeSelector(
                options: AnalysisState.options,
                selectedIndex: state.selectedIndex,
                onSelect: (idx) => context
                    .read<AnalysisBloc>()
                    .add(SelectRangeIndexEvent(index: idx)),
                labelText: state.labelText,
                onPrevious: () =>
                    context.read<AnalysisBloc>().add(const GoToPreviousEvent()),
                onNext: () =>
                    context.read<AnalysisBloc>().add(const GoToNextEvent()),
                getIcon: state.getIconFor,
              ),
              const ExpenseChart(
                title: 'Withdrawal details',
                amount: '33,100.00',
              ),
            ],
          ),
        );
      },
    );
  }
}