import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trucky/presentation/analysis/bloc/analysis_bloc.dart';
import 'package:trucky/presentation/analysis/bloc/analysis_event.dart';
import 'package:trucky/presentation/analysis/widgets/business_analysis.dart';
import 'package:trucky/presentation/analysis/widgets/cash_flow.dart';
import 'package:trucky/presentation/analysis/widgets/expenses.dart';
import 'package:trucky/presentation/analysis/widgets/withdrawals.dart';
import 'package:trucky/presentation/analysis/widgets/working_capital.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_bloc.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_models.dart';
import 'package:trucky/presentation/widgets/custom_app_bar.dart';
import 'package:trucky/presentation/widgets/custom_scaffold.dart';

/// Analysis screen: business, working capital, expenses, cash flow,
/// and withdrawals sections.
class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  static const _saleTypes = {'Sale', 'Return'};
  static const _purchaseTypes = {'Purchase', 'Return'};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final csState = context.read<ClientSuppBloc>().state;
      context.read<AnalysisBloc>().add(
            LoadAnalysisEvent(
              saleAmount: _sumByType(
                csState.clientTxns,
                _saleTypes,
              ),
              purchaseAmount: _sumByType(
                csState.supplierTxns,
                _purchaseTypes,
              ),
            ),
          );
    });
  }

  double _sumByType(List<ClientSuppTxn> txns, Set<String> types) {
    return txns
        .where((t) => types.contains(t.paymentType))
        .fold<double>(0, (sum, t) => sum + (double.tryParse(t.amount) ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Analysis'),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            BusinessAnalysis(),
            WorkingCapital(),
            Expenses(),
            CashFlow(),
            Withdrawals(),
          ],
        ),
      ),
    );
  }
}