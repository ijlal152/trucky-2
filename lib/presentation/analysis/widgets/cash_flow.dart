import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/constants/font_constants.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/analysis/bloc/analysis_bloc.dart';
import 'package:trucky/presentation/analysis/bloc/analysis_event.dart';
import 'package:trucky/presentation/analysis/bloc/analysis_state.dart';
import 'package:trucky/presentation/analysis/widgets/business_analysis_item.dart';
import 'package:trucky/presentation/analysis/widgets/time_range_selector.dart';
import 'package:trucky/presentation/widgets/custom_decorated_container.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// Cash flow section: income/cost and expenses/cashflow balances.
class CashFlow extends StatelessWidget {
  const CashFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalysisBloc, AnalysisState>(
      builder: (context, state) {
        return DecoratedContainer(
          width: double.infinity,
          borderRadius: 16,
          margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 20.h),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LabelWidget(
                text: 'Cash flow',
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
              _incomeAndCost(),
              _expensesAndCashFlow(),
            ],
          ),
        );
      },
    );
  }

  Widget _incomeAndCost() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        businessAnalysisItem(
          title: 'Income',
          amount: '122415740',
          isProfit: true,
          percentage: '8',
        ),
        businessAnalysisItem(
          title: 'Cost',
          amount: '122415740',
          isProfit: false,
          percentage: '11',
        ),
      ],
    ).marginOnly(bottom: 25.h);
  }

  Widget _expensesAndCashFlow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        businessAnalysisItem(
          title: 'Expenses',
          amount: '122415740',
          isProfit: true,
          percentage: '8',
        ),
        businessAnalysisItem(
          title: 'Cashflow',
          amount: '122415740',
          isProfit: true,
          percentage: '11',
        ),
      ],
    );
  }
}