import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/constants/constants.dart';
import 'package:trucky/core/constants/font_constants.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// Horizontal selector for payment types (All, Sales, Payments, ...).
class PaymentTypeSelector extends StatelessWidget {
  final List<PaymentTypeSelectorModel> paymentTypes;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const PaymentTypeSelector({
    super.key,
    required this.paymentTypes,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35.h,
      child: ListView.separated(
        itemCount: paymentTypes.length,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              padding: EdgeInsets.only(
                top: 6.h,
                left: 8.w,
                right: 16.w,
                bottom: 6.h,
              ),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFA1D5E2) : null,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: !isSelected ? Colors.black : Colors.transparent,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  index == 0
                      ? !isSelected
                            ? const SizedBox.shrink()
                            : Image.asset(
                                paymentTypes[index].img.toString(),
                                height: 11.h,
                              )
                      : Image.asset(
                          isSelected
                              ? paymentTypes[0].img.toString()
                              : paymentTypes[index].img.toString(),
                          height: isSelected ? 11.h : 18.h,
                        ),
                  4.horizontalSpace,
                  LabelWidget(
                    text: paymentTypes[index].paymentType,
                    fontFamily: FontConstants.interSemiBold,
                    textSize: 14.sp,
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => 8.horizontalSpace,
      ),
    );
  }
}
