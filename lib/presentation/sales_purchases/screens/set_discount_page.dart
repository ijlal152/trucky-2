import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:trucky/core/utils/number_formater.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_bloc.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_event.dart';
import 'package:trucky/presentation/sales_purchases/widgets/quantity_control_widget.dart';
import 'package:trucky/presentation/widgets/custom_app_bar.dart';
import 'package:trucky/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:trucky/presentation/widgets/custom_elevated_button.dart';
import 'package:trucky/presentation/widgets/custom_scaffold.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// Applies a cash and/or percentage discount to the current cart total.
class SetDiscountPage extends StatefulWidget {
  const SetDiscountPage({super.key});

  @override
  State<SetDiscountPage> createState() => _SetDiscountPageState();
}

class _SetDiscountPageState extends State<SetDiscountPage> {
  late final TextEditingController _cashDiscountController;
  late final TextEditingController _percentageDiscountController;

  @override
  void initState() {
    super.initState();
    final state = context.read<SalePurchaseBloc>().state;
    _cashDiscountController = TextEditingController(
      text: state.discountCash > 0 ? state.discountCash.toString() : '',
    );
    _percentageDiscountController = TextEditingController(
      text: state.discountPercentage > 0
          ? state.discountPercentage.toString()
          : '',
    );
  }

  @override
  void dispose() {
    _cashDiscountController.dispose();
    _percentageDiscountController.dispose();
    super.dispose();
  }

  void _onCashChanged(String amount) {
    final state = context.read<SalePurchaseBloc>().state;
    if (amount.isNotEmpty && state.subtotal > 0) {
      final cash = double.tryParse(amount) ?? 0;
      _percentageDiscountController.text = (cash / state.subtotal * 100)
          .toStringAsFixed(2);
    } else {
      _percentageDiscountController.clear();
    }
  }

  void _onPercentageChanged(String percentage) {
    final state = context.read<SalePurchaseBloc>().state;
    if (percentage.isNotEmpty && state.subtotal > 0) {
      final percent = double.tryParse(percentage) ?? 0;
      _cashDiscountController.text =
          (state.subtotal * percent / 100).toStringAsFixed(2);
    } else {
      _cashDiscountController.clear();
    }
  }

  void _onValidate() {
    final cash = double.tryParse(_cashDiscountController.text) ?? 0.0;
    final percentage = double.tryParse(_percentageDiscountController.text) ?? 0.0;
    context
        .read<SalePurchaseBloc>()
        .add(SetDiscountEvent(cash: cash, percentage: percentage));
    context.pop();
  }

  void _onCancel() {
    context
        .read<SalePurchaseBloc>()
        .add(const ClearDiscountEvent());
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<SalePurchaseBloc>().state;

    return CustomScaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Discount',
        leadingOnTap: _onCancel,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LabelWidget(
              text: 'Discount on',
              textSize: 24.sp,
              fontWeight: FontWeight.w500,
            ),
            10.verticalSpace,
            LabelWidget(
              text: NumberFormater.formatAmount(
                state.subtotal.toString(),
                showCurrency: true,
              ),
              textSize: 24.sp,
              fontWeight: FontWeight.w600,
            ),
            50.verticalSpace,
            LabelWidget(
              text: 'Cash discount',
              textSize: 14.sp,
              fontWeight: FontWeight.w600,
              textColor: const Color.fromRGBO(92, 97, 111, 1),
            ),
            10.verticalSpace,
            CustomNumberField(
              leftDottedMargin: 50,
              rightDottedMargin: 50,
              fontSize: 40.sp,
              controller: _cashDiscountController,
              onChanged: _onCashChanged,
            ),
            50.verticalSpace,
            LabelWidget(
              text: 'Percentage discount (%)',
              textSize: 14.sp,
              fontWeight: FontWeight.w600,
              textColor: const Color.fromRGBO(92, 97, 111, 1),
            ),
            10.verticalSpace,
            CustomNumberField(
              leftDottedMargin: 50,
              rightDottedMargin: 50,
              fontSize: 40.sp,
              controller: _percentageDiscountController,
              onChanged: _onPercentageChanged,
            ),
            40.verticalSpace,
            LabelWidget(
              text: 'New amount',
              textSize: 24.sp,
              fontWeight: FontWeight.w500,
              textColor: const Color.fromRGBO(92, 97, 111, 1),
            ),
            10.verticalSpace,
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _cashDiscountController,
              builder: (context, cashValue, _) {
                return ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _percentageDiscountController,
                  builder: (context, percentValue, _) {
                    final cash = double.tryParse(cashValue.text) ?? 0;
                    final percent = double.tryParse(percentValue.text) ?? 0;
                    final discount = cash + state.subtotal * percent / 100;
                    final newAmount = state.subtotal - discount;
                    return LabelWidget(
                      text: NumberFormater.formatAmount(
                        newAmount.toString(),
                        showCurrency: true,
                      ),
                      textSize: 24.sp,
                      fontWeight: FontWeight.w600,
                    );
                  },
                );
              },
            ),
          ],
        ).paddingSymmetric(horizontal: 50.w),
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
