import 'package:flutter/material.dart';

/// State exposed by [AnalysisBloc].
class AnalysisState {
  AnalysisState({
    this.selectedIndex = 2,
    DateTime? currentDate,
    this.saleAmount = 0,
    this.purchaseAmount = 0,
  }) : currentDate = currentDate ?? DateTime.now();

  /// Index into [options] (defaults to "Month").
  final int selectedIndex;
  final DateTime currentDate;
  final double saleAmount;
  final double purchaseAmount;

  static const List<String> options = ['Day', 'Week', 'Month', 'Year', 'Period'];

  AnalysisState copyWith({
    int? selectedIndex,
    DateTime? currentDate,
    double? saleAmount,
    double? purchaseAmount,
  }) {
    return AnalysisState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      currentDate: currentDate ?? this.currentDate,
      saleAmount: saleAmount ?? this.saleAmount,
      purchaseAmount: purchaseAmount ?? this.purchaseAmount,
    );
  }

  String get selectedLabel => options[selectedIndex];

  String get _monthName {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[currentDate.month - 1];
  }

  /// Human-friendly label for the current range, e.g. "March 2024".
  String get labelText {
    final date = currentDate;
    switch (selectedLabel) {
      case 'Month':
        return '$_monthName ${date.year}';
      case 'Year':
        return '${date.year}';
      case 'Week':
        final startOfWeek =
            date.subtract(Duration(days: date.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        return '${startOfWeek.day} ${_nameOfMonth(startOfWeek.month)} - '
            '${endOfWeek.day} ${_nameOfMonth(endOfWeek.month)}';
      case 'Day':
        return '${date.day} $_monthName, ${date.year}';
      case 'Period':
        return 'Select Range';
      default:
        return '';
    }
  }

  /// Icon shown next to a range option in the selector.
  IconData getIconFor(String label) {
    switch (label) {
      case 'Day':
        return Icons.view_day_rounded;
      case 'Week':
        return Icons.view_week_rounded;
      case 'Month':
        return Icons.calendar_today;
      case 'Year':
        return Icons.grid_view;
      case 'Period':
        return Icons.calendar_today_outlined;
      default:
        return Icons.circle;
    }
  }

  /// Moves [currentDate] backward by one range step.
  AnalysisState goToPrevious() {
    final date = currentDate;
    switch (selectedLabel) {
      case 'Month':
        return copyWith(currentDate: DateTime(date.year, date.month - 1));
      case 'Year':
        return copyWith(currentDate: DateTime(date.year - 1, date.month));
      case 'Week':
        return copyWith(currentDate: date.subtract(const Duration(days: 7)));
      case 'Day':
        return copyWith(currentDate: date.subtract(const Duration(days: 1)));
      default:
        return this;
    }
  }

  /// Moves [currentDate] forward by one range step.
  AnalysisState goToNext() {
    final date = currentDate;
    switch (selectedLabel) {
      case 'Month':
        return copyWith(currentDate: DateTime(date.year, date.month + 1));
      case 'Year':
        return copyWith(currentDate: DateTime(date.year + 1, date.month));
      case 'Week':
        return copyWith(currentDate: date.add(const Duration(days: 7)));
      case 'Day':
        return copyWith(currentDate: date.add(const Duration(days: 1)));
      default:
        return this;
    }
  }

  static String _nameOfMonth(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}