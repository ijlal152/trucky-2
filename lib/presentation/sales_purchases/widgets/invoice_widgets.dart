import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/constants/font_constants.dart';
import 'package:trucky/core/utils/number_formater.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_models.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// Invoice header with the shop name, sale number and date.
class InvoiceHeader extends StatelessWidget {
  const InvoiceHeader({
    super.key,
    this.name = '',
    this.date = '',
    this.saleNumber = 'Sale N° YY/001',
  });

  final String name;
  final String date;
  final String saleNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        20.verticalSpace,
        LabelWidget(
          text: name,
          textSize: 16.sp,
          textColor: const Color.fromRGBO(54, 61, 78, 1),
          fontWeight: FontWeight.w500,
        ),
        15.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LabelWidget(
              text: saleNumber,
              textColor: const Color.fromRGBO(54, 61, 78, 1),
              fontWeight: FontWeight.w500,
              textSize: 16.sp,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: LabelWidget(
                  text: date,
                  textColor: const Color.fromRGBO(54, 61, 78, 1),
                  fontWeight: FontWeight.w500,
                  textSize: 16.sp,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ],
    ).paddingSymmetric(horizontal: 20.w);
  }
}

/// The invoice product lines plus the paid/old/new balance summary.
class InvoiceBodyWidget extends StatelessWidget {
  const InvoiceBodyWidget({
    super.key,
    this.selectedProducts = const [],
    this.paidAmt = '0.00',
    this.oldBalance = '0.00',
    this.newBalance = '0.00',
  });

  final List<CartItem> selectedProducts;
  final String paidAmt;
  final String oldBalance;
  final String newBalance;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          15.verticalSpace,
          const _InvoiceDivider(),
          Flexible(
            child: ListView.separated(
              itemCount: selectedProducts.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final item = selectedProducts[index];
                return SizedBox(
                  height: 72.h,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Text.rich(
                      TextSpan(
                        text: '${item.quantity}',
                        children: const [
                          TextSpan(text: ' '),
                          TextSpan(
                            text: 'X',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: FontConstants.interSemiBold,
                              color: Color.fromRGBO(92, 97, 111, 1),
                            ),
                          ),
                        ],
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: FontConstants.interBold,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    title: LabelWidget(
                      text: item.product.productName,
                      textColor: Colors.black,
                      fontWeight: FontWeight.w700,
                      textSize: 16.sp,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: LabelWidget(
                      text: NumberFormater.formatAmount(
                        item.unitPrice.toString(),
                        showCurrency: true,
                      ),
                      textColor: Colors.black,
                      fontWeight: FontWeight.w500,
                      textSize: 16.sp,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: LabelWidget(
                      text: NumberFormater.formatAmount(
                        item.lineTotal.toString(),
                        showCurrency: true,
                      ),
                      textColor: Colors.black,
                      fontWeight: FontWeight.normal,
                      textSize: 16.sp,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
          ),
          5.verticalSpace,
          const _InvoiceDivider(),
          balanceCalculation(paidAmt, oldBalance, newBalance),
        ],
      ).paddingSymmetric(horizontal: 20.w),
    );
  }

  Widget balanceCalculation(String paid, String oldBalance, String newBalance) {
    return Column(
      children: [
        balanceWidget(title: 'Paid', amount: paid),
        balanceWidget(title: 'Old Balance', amount: oldBalance),
        balanceWidget(title: 'New Balance', amount: newBalance),
      ],
    ).paddingOnly(bottom: 20.h);
  }

  Widget balanceWidget({required String title, required String amount}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        LabelWidget(
          text: '$title : ',
          textColor: const Color.fromRGBO(54, 61, 78, 1),
          fontWeight: FontWeight.normal,
          textSize: 16.sp,
        ),
        LabelWidget(
          text: NumberFormater.formatAmount(amount, showCurrency: true),
          textColor: const Color.fromRGBO(54, 61, 78, 1),
          fontWeight: FontWeight.normal,
          textSize: 16.sp,
        ),
      ],
    ).paddingOnly(top: 10.h);
  }
}

class _InvoiceDivider extends StatelessWidget {
  const _InvoiceDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      color: Colors.black,
      margin: EdgeInsets.symmetric(vertical: 5.h),
    );
  }
}
