import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:trucky/core/constants/enums.dart';
import 'package:trucky/core/constants/route_paths.dart';
import 'package:trucky/core/utils/extensions.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_bloc.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_models.dart';
import 'package:trucky/presentation/sales_purchases/sale_purchase_persistence.dart';
import 'package:trucky/presentation/sales_purchases/widgets/payment_details_widgets.dart';
import 'package:trucky/presentation/widgets/custom_app_bar.dart';
import 'package:trucky/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:trucky/presentation/widgets/custom_elevated_button.dart';
import 'package:trucky/presentation/widgets/custom_scaffold.dart';

/// Records/edits the payment amount and notes for a transaction.
class PaymentDetailsPage extends StatefulWidget {
  const PaymentDetailsPage({super.key});

  @override
  State<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  late TextEditingController paymentAmountController;
  late TextEditingController notesController;
  late PaymentDataModel currentPaymentData;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    notesController = TextEditingController();
    paymentAmountController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final data = GoRouterState.of(context).extra as PaymentDataModel?;
    currentPaymentData = data ??
        PaymentDataModel.directPayment(
          clientSupplier: null,
          oldBalance: 0,
        );

    notesController.text = currentPaymentData.notes;
    final initialAmount =
        currentPaymentData.paymentType == PaymentTransactionType.directPayment ||
                currentPaymentData.paymentType == PaymentTransactionType.refund
            ? currentPaymentData.paymentAmount.toStringAsFixed(2)
            : '';
    paymentAmountController.text = initialAmount;
  }

  @override
  void dispose() {
    paymentAmountController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void _updatePaymentAmount(String amount) {
    final paymentAmount = double.tryParse(amount) ?? 0.0;
    setState(() {
      currentPaymentData = currentPaymentData.copyWith(
        paymentAmount: paymentAmount,
      );
    });
  }

  Future<void> _onValidate() async {
    final updatedData = currentPaymentData.copyWith(
      notes: notesController.text,
      dateTime: DateTime.now(),
    );

    final state = context.read<SalePurchaseBloc>().state;
    if (state.operationType == OperationType.edit) {
      final oldTxn = state.selectedTxn;
      if (oldTxn != null) {
        await SalePurchasePersistence.editTransaction(
          context,
          updatedData,
          oldTxn,
        );
      } else {
        SalePurchasePersistence.addTransaction(context, updatedData);
      }
    } else {
      SalePurchasePersistence.addTransaction(context, updatedData);
    }
    if (!mounted) return;

    final isOrder =
        updatedData.paymentType == PaymentTransactionType.salePayment ||
        updatedData.paymentType == PaymentTransactionType.returnPayment;
    if (isOrder) {
      context.push(RoutePaths.invoice, extra: updatedData);
    } else {
      context.go(
        state.returnToDashboard
            ? RoutePaths.clientSuppDashboard
            : RoutePaths.salePurchase,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOrder =
        currentPaymentData.paymentType == PaymentTransactionType.salePayment ||
        currentPaymentData.paymentType == PaymentTransactionType.returnPayment;

    return CustomScaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Payment Details'),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NameAndDateWidget(
                name: currentPaymentData.clientSupplier?.name ?? '',
                currentDate: DateTime.now().showMonthNameWithTime(false),
              ),
              PaymentDetailsWidget(
                oldBalance:
                    currentPaymentData.oldBalance.toStringAsFixed(2),
                currentOrderAmount: currentPaymentData.currentOrderAmount > 0
                    ? currentPaymentData.currentOrderAmount.toStringAsFixed(2)
                    : '',
                currentBalance:
                    currentPaymentData.currentBalance.toStringAsFixed(2),
                showCurrentOrderAmount: isOrder,
                showCurrentBalance: isOrder,
              ),
              PaymentAmountField(
                controller: paymentAmountController,
                onChanged: _updatePaymentAmount,
                payCashAmount: currentPaymentData.currentBalance,
                showPayCashButton: isOrder,
              ),
              NewBalanceAndNotesField(
                newBalance: currentPaymentData.newBalance.toStringAsFixed(2),
                notesController: notesController,
              ),
            ],
          ).paddingSymmetric(horizontal: 20.w, vertical: 20.h),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBarWidget(
        widget: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomElevatedButton(
              onTap: _onValidate,
              btnTitle: 'Validate',
            ),
          ],
        ),
      ),
    );
  }
}
