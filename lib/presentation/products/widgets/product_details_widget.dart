import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/constants/font_constants.dart';
import 'package:trucky/core/utils/number_formater.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/products/bloc/product_bloc.dart';
import 'package:trucky/presentation/widgets/custom_divider.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

class ProductDetailsListWidget extends StatelessWidget {
  final List<ProductDetail> list;

  const ProductDetailsListWidget({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return list.isEmpty
        ? const Center(child: LabelWidget(text: 'No Record Found.'))
        : ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: list.length,
            itemBuilder: (context, index) {
              final productDetail = list[index];
              return GestureDetector(
                onTap: () {},
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 10.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            setIconBasedOnPaymentType(index),
                            8.horizontalSpace,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LabelWidget(
                                  text:
                                      productDetail.sourceName?.isNotEmpty ==
                                              true
                                          ? productDetail.sourceName.toString()
                                          : productDetail.paymentType,
                                  textSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                LabelWidget(
                                  text: formatDate(productDetail.createdAt),
                                  textSize: 11.sp,
                                  fontWeight: FontWeight.normal,
                                  textColor: const Color.fromRGBO(
                                    92,
                                    97,
                                    111,
                                    1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            LabelWidget(
                              text:
                                  '${getSignBasedOnPaymentType(productDetail.paymentType, productDetail.sourceType ?? '')}${productDetail.quantity} Pcs',
                              textSize: 16.sp,
                              fontFamily: FontConstants.interSemiBold,
                              textColor: setAmountColorBasedOnPaymentType(
                                index,
                              ),
                            ),
                            LabelWidget(
                              text: NumberFormater.formatStringToCurrency(
                                getProductPrice(productDetail) ?? '',
                              ),
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

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy - hh:mm a').format(date);
  }

  String? getProductPrice(ProductDetail product) {
    final isClient = product.sourceType == 'client';
    final isSupplier = product.sourceType == 'supplier';

    switch (product.paymentType) {
      case 'Sale':
        return product.sellingPrice.toString();
      case 'Purchase':
        return isSupplier
            ? product.purchasePrice.toString()
            : product.sellingPrice.toString();
      case 'Return':
        return isClient
            ? product.sellingPrice.toString()
            : isSupplier
            ? product.purchasePrice.toString()
            : product.sellingPrice.toString();
      default:
        return product.sellingPrice.toString();
    }
  }

  Widget setIconBasedOnPaymentType(int index) {
    const double iconSize = 42;

    final Map<String, String> paymentTypeIcons = {
      'Initial Stock': AppAssets.images.supplierIcon,
      'Sale': AppAssets.images.sellsIcon,
      'Purchase': AppAssets.images.supplierIcon,
      'Payment': AppAssets.images.supplierIcon,
      'Return': AppAssets.images.returnIcon,
      'Refund': AppAssets.images.negativeRefundIcon,
    };

    final String? iconPath = paymentTypeIcons[list[index].paymentType];

    if (iconPath != null) {
      return Image.asset(iconPath, height: iconSize.h, width: iconSize.h);
    }

    return const SizedBox.shrink();
  }

  Color setAmountColorBasedOnPaymentType(int index) {
    const Map<String, Color> paymentTypeColors = {
      'Initial Stock': Color.fromRGBO(0, 177, 103, 1),
      'Sale': Color.fromRGBO(255, 124, 111, 1),
      'Payment': Color.fromRGBO(0, 177, 103, 1),
      'Return': Color.fromRGBO(43, 136, 216, 1),
    };

    return paymentTypeColors[list[index].paymentType] ??
        const Color.fromRGBO(43, 136, 216, 1);
  }

  String getSignBasedOnPaymentType(
    String paymentType, [
    String sourceType = '',
  ]) {
    switch (paymentType) {
      case 'Initial Stock':
        return '+';
      case 'Sale':
        return '-';
      case 'Purchase':
        return '+';
      case 'Return':
        return sourceType == 'client' ? '+' : '-';
      default:
        return '';
    }
  }
}
