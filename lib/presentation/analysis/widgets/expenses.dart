import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/constants/font_constants.dart';
import 'package:trucky/presentation/analysis/bloc/analysis_bloc.dart';
import 'package:trucky/presentation/analysis/bloc/analysis_event.dart';
import 'package:trucky/presentation/analysis/bloc/analysis_state.dart';
import 'package:trucky/presentation/analysis/widgets/time_range_selector.dart';
import 'package:trucky/presentation/widgets/custom_decorated_container.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// Expenses section with a donut chart and per-type bars.
class Expenses extends StatelessWidget {
  const Expenses({super.key});

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
                text: 'Expenses',
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
              const ExpenseChart(title: 'Expense Total', amount: '33,100.00'),
            ],
          ),
        );
      },
    );
  }
}

/// Pie chart with a breakdown list of expense types.
class ExpenseChart extends StatelessWidget {
  const ExpenseChart({super.key, required this.title, required this.amount});

  final String title;
  final String amount;

  static const List<Color> _sectionColors = [
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.orange,
    Colors.green,
  ];

  static const List<double> _values = [11500, 7500, 2500, 5800, 5800];

  static const List<String> _labels = [
    'Expense Type 1',
    'Expense Type 2',
    'Expense Type 3',
    'Expense Type 4',
    'Expense Type 5',
  ];

  @override
  Widget build(BuildContext context) {
    final total = _values.fold(0.0, (a, b) => a + b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelWidget(
                    text: title,
                    textSize: 18.sp,
                    textColor: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                  4.verticalSpace,
                  LabelWidget(
                    text: '${total.toStringAsFixed(2)} DZD',
                    textSize: 20.sp,
                    textColor: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 144.w,
              width: 144.w,
              child: PieChart(
                PieChartData(
                  sections: List.generate(
                    _values.length,
                    (i) => PieChartSectionData(
                      value: _values[i],
                      color: _sectionColors[i],
                      radius: 10.r,
                      showTitle: false,
                    ),
                  ),
                  centerSpaceRadius: 50,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ],
        ),
        10.verticalSpace,
        ...List.generate(_values.length, (i) {
          final percentage = (_values[i] / total) * 100;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: LabelWidget(
                        text:
                            '${_labels[i]} (${percentage.toStringAsFixed(2)}%)',
                        textSize: 14.sp,
                        textColor: const Color.fromRGBO(0, 0, 0, 0.6),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    LabelWidget(
                      text: '${_values[i].toStringAsFixed(2)} DZD',
                      textSize: 14.sp,
                      textColor: const Color.fromRGBO(0, 0, 0, 0.6),
                      fontWeight: FontWeight.normal,
                    ),
                  ],
                ),
                4.verticalSpace,
                LinearProgressIndicator(
                  value: _values[i] / total,
                  color: _sectionColors[i],
                  backgroundColor: Colors.grey[200],
                  minHeight: 5.h,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}