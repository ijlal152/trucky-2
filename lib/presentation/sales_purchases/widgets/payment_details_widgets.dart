import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/constants/font_constants.dart';
import 'package:trucky/core/utils/number_formater.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/sales_purchases/widgets/quantity_control_widget.dart';
import 'package:trucky/presentation/widgets/custom_decorated_container.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// Header row with the selected client/supplier name and current date.
class NameAndDateWidget extends StatelessWidget {
  const NameAndDateWidget({
    super.key,
    this.name,
    this.currentDate,
    this.onTap,
  });

  final String? name;
  final String? currentDate;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _borderWidget(text: name ?? '', onTap: onTap),
        _borderWidget(text: currentDate ?? '', onTap: onTap),
      ],
    );
  }

  Widget _borderWidget({required String text, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(5.r),
        constraints: const BoxConstraints(maxWidth: 150),
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromRGBO(121, 116, 126, 1)),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(child: LabelWidget(text: text, maxLines: 2)),
      ),
    );
  }
}

/// Old balance, current order amount and current balance summary.
class PaymentDetailsWidget extends StatelessWidget {
  const PaymentDetailsWidget({
    super.key,
    this.oldBalance = '',
    this.currentOrderAmount = '',
    this.currentBalance = '',
    this.showCurrentOrderAmount = true,
    this.showCurrentBalance = true,
  });

  final String oldBalance;
  final String currentOrderAmount;
  final String currentBalance;
  final bool showCurrentOrderAmount;
  final bool showCurrentBalance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: LabelWidget(text: 'Transaction details', textSize: 20.sp),
        ),
        balanceAmtWidget(label: 'Old Balance', amount: oldBalance),
        if (showCurrentOrderAmount)
          balanceAmtWidget(label: 'Current Order Amount', amount: currentOrderAmount),
        if (showCurrentBalance)
          balanceAmtWidget(label: 'Current Balance', amount: currentBalance),
      ],
    ).paddingOnly(top: 40.h);
  }
}

Widget balanceAmtWidget({required String label, required String amount}) {
  if (amount.isEmpty) return const SizedBox.shrink();
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      LabelWidget(text: label, textSize: 16.sp, fontWeight: FontWeight.w500),
      LabelWidget(
        text: NumberFormater.formatAmount(amount, showCurrency: true),
        textSize: 16.sp,
        fontWeight: FontWeight.w600,
      ),
    ],
  ).paddingOnly(top: 10.h);
}

/// Editable payment amount field with a "Pay Cash" quick-fill button.
class PaymentAmountField extends StatelessWidget {
  const PaymentAmountField({
    super.key,
    this.controller,
    this.keyboardType = const TextInputType.numberWithOptions(decimal: true),
    this.inputFormatters,
    this.onChanged,
    this.leftDottedMargin = 60,
    this.rightDottedMargin = 60,
    this.fontSize = 32,
    this.payCashAmount,
    this.showPayCashButton = true,
  });

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final double leftDottedMargin;
  final double rightDottedMargin;
  final double fontSize;
  final double? payCashAmount;
  final bool showPayCashButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(),
        20.verticalSpace,
        LabelWidget(
          text: 'Payment Amount',
          textSize: 16.sp,
          fontFamily: FontConstants.interSemiBold,
        ),
        CustomNumberField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          leftDottedMargin: leftDottedMargin,
          rightDottedMargin: rightDottedMargin,
          fontSize: fontSize,
        ),
        20.verticalSpace,
        if (showPayCashButton)
          GestureDetector(
            onTap: () {
              if (payCashAmount != null && controller != null) {
                controller!.text = payCashAmount!.toStringAsFixed(2);
                onChanged?.call(controller!.text);
              }
            },
            child: DecoratedContainer(
              borderRadius: 40.r,
              width: 108.w,
              height: 40.h,
              border: Border.all(color: const Color.fromRGBO(121, 116, 126, 1)),
              child: const Center(child: LabelWidget(text: 'Pay Cash')),
            ),
          ),
        if (showPayCashButton) 20.verticalSpace,
        const Divider(),
      ],
    );
  }
}

/// New balance summary and a notes field.
class NewBalanceAndNotesField extends StatelessWidget {
  const NewBalanceAndNotesField({
    super.key,
    this.newBalance = '',
    this.notesController,
  });

  final String newBalance;
  final TextEditingController? notesController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        balanceAmtWidget(label: 'New Balance', amount: newBalance)
            .paddingOnly(bottom: 10.h),
        const Divider(),
        TextFormField(
          controller: notesController,
          decoration: const InputDecoration(
            hintText: 'Add note here',
            labelText: 'Notes',
            labelStyle: TextStyle(
              fontFamily: FontConstants.inter,
              color: Color.fromRGBO(92, 97, 111, 1),
              fontWeight: FontWeight.w600,
            ),
            border: InputBorder.none,
          ),
          style: TextStyle(
            fontSize: 17.sp,
            fontFamily: FontConstants.inter,
            color: const Color.fromRGBO(4, 12, 34, 1),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
