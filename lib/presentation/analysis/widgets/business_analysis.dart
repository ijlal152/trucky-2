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

/// Business Analysis section with sales/income/purchase/profit breakdown.
class BusinessAnalysis extends StatelessWidget {
  const BusinessAnalysis({super.key});

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
              _sectionTitle('Business Analysis'),
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
              _salesAndIncome(state.saleAmount),
              _purchaseAndCost(state.purchaseAmount),
              _expenseAndGrossProfit(),
              _netProfit(),
            ],
          ),
        );
      },
    );
  }

  Widget _salesAndIncome(double totalSales) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        businessAnalysisItem(
          title: 'Sale',
          amount: totalSales.toStringAsFixed(2),
          isProfit: true,
          percentage: '8',
        ),
        businessAnalysisItem(
          title: 'Income',
          amount: '122415740',
          isProfit: false,
          percentage: '11',
        ),
      ],
    ).marginOnly(bottom: 25.h);
  }

  Widget _purchaseAndCost(double totalPurchases) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        businessAnalysisItem(
          title: 'Purchase',
          amount: totalPurchases.toStringAsFixed(2),
          isProfit: true,
          percentage: '8',
        ),
        businessAnalysisItem(
          title: 'Cost',
          amount: '122415740',
          isProfit: true,
          percentage: '11',
        ),
      ],
    ).marginOnly(bottom: 25.h);
  }

  Widget _expenseAndGrossProfit() {
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
          title: 'Gross Profit',
          amount: '122415740',
          isProfit: true,
          percentage: '11',
        ),
      ],
    ).marginOnly(bottom: 25.h);
  }

  Widget _netProfit() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        businessAnalysisItem(
          title: 'Net Profit',
          amount: '122415740',
          isProfit: true,
          percentage: '8',
        ),
      ],
    );
  }

  Widget _sectionTitle(String text) {
    return LabelWidget(
      text: text,
      textSize: 20.sp,
      textColor: Colors.black,
      fontWeight: FontWeight.w500,
      fontFamily: FontConstants.interSemiBold,
    );
  }
}