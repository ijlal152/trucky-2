import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/constants/font_constants.dart';
import 'package:trucky/core/utils/number_formater.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/treasury/bloc/treasury_models.dart';
import 'package:trucky/presentation/widgets/custom_divider.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// Cash-flow list row used on the Treasury screen.
class TreasuryListWidget extends StatelessWidget {
  const TreasuryListWidget({super.key, required this.list});

  final List<TreasuryModel> list;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return GestureDetector(
          onTap: () {},
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(item.img, height: 42.h, width: 42.h),
                      8.horizontalSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LabelWidget(
                            text: item.name,
                            textSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          LabelWidget(
                            text: '${item.date} at ${item.time}',
                            textSize: 11.sp,
                            fontWeight: FontWeight.normal,
                            textColor: const Color.fromRGBO(92, 97, 111, 1),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      LabelWidget(
                        text: NumberFormater.formatStringToCurrency(item.amount),
                        textSize: 16.sp,
                        fontFamily: FontConstants.interSemiBold,
                        textColor: _amountColor(item),
                      ),
                      LabelWidget(
                        text: item.status,
                        textSize: 11.sp,
                        textColor: const Color.fromRGBO(92, 97, 111, 1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: dividerWidget(),
        );
      },
    ).paddingOnly(top: 10.h);
  }

  Color _amountColor(TreasuryModel item) {
    if (item.status.contains('Expense') ||
        item.status.contains('-Payment')) {
      return const Color.fromRGBO(255, 124, 111, 1);
    }
    if (item.status.contains('Refund')) {
      return const Color.fromRGBO(43, 136, 216, 1);
    }
    return const Color.fromRGBO(0, 177, 103, 1);
  }
}