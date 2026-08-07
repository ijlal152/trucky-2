import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/constants/font_constants.dart';
import 'package:trucky/core/utils/number_formater.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/products/bloc/product_models.dart';
import 'package:trucky/presentation/products/widgets/product_image.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

class ProductInfoWidget extends StatelessWidget {
  final Product selectedProduct;
  final String currency;

  const ProductInfoWidget({
    super.key,
    required this.selectedProduct,
    this.currency = '',
  });

  int get availableStock => selectedProduct.availableStock;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildProductImage(
              base64Image: selectedProduct.productImage,
              imgHeight: 90.h,
              imgWidth: 90.w,
              isRoundImg: false,
            ),
            10.verticalSpace,
            LabelWidget(
              text: 'Price',
              textColor: Colors.white,
              textSize: 14.sp,
              fontFamily: FontConstants.interSemiBold,
            ),
            Row(
              children: [
                LabelWidget(
                  text: NumberFormater.formatAmount(
                    selectedProduct.sellingPrice.toString(),
                    showCurrency: false,
                  ),
                  textColor: Colors.white,
                  textSize: 16.sp,
                  fontFamily: FontConstants.interBold,
                ),
                5.horizontalSpace,
                LabelWidget(
                  text: '$currency ',
                  textColor: Colors.white,
                  textSize: 16.sp,
                  fontWeight: FontWeight.normal,
                ),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            LabelWidget(
              text: 'Stock Available',
              textColor: Colors.white,
              textSize: 17.sp,
              fontFamily: FontConstants.interSemiBold,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (selectedProduct.quantityPerPackage != null &&
                    selectedProduct.quantityPerPackage!.isNotEmpty)
                  LabelWidget(
                    text: availableStock.toString(),
                    textColor: Colors.white,
                    textSize: 24.sp,
                    fontFamily: FontConstants.interBold,
                  ),
                if (selectedProduct.quantityPerPackage != null &&
                    selectedProduct.quantityPerPackage!.isNotEmpty &&
                    availableStock > 0)
                  LabelWidget(
                    text: ' Pcs ',
                    textColor: Colors.white,
                    textSize: 24.sp,
                    fontWeight: FontWeight.normal,
                  ),
                availableStock <= 0
                    ? const SizedBox.shrink()
                    : LabelWidget(
                        text: formatStockDetails(
                          availableStock.toString(),
                          selectedProduct.quantityPerPackage ?? '0',
                        ),
                        textColor: Colors.white,
                        textSize: 24.sp,
                      ),
              ],
            ),
            30.verticalSpace,
            LabelWidget(
              text: 'Stock Value',
              textColor: Colors.white,
              textSize: 16.sp,
              fontFamily: FontConstants.interBold,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                LabelWidget(
                  text: NumberFormater.formatAmount(
                    calcAvailableStockValue().toString(),
                  ),
                  textColor: Colors.white,
                  textSize: 24.sp,
                  fontFamily: FontConstants.interBold,
                ),
                LabelWidget(
                  text: ' $currency ',
                  textColor: Colors.white,
                  textSize: 24.sp,
                  fontWeight: FontWeight.normal,
                ),
              ],
            ),
          ],
        ),
      ],
    ).paddingSymmetric(horizontal: 20.w);
  }

  double calcAvailableStockValue() {
    return selectedProduct.availableStock * selectedProduct.effectiveCost;
  }

  String formatStockDetails(String totalUnitsStr, String unitsPerPackageStr) {
    final totalUnits = int.tryParse(totalUnitsStr) ?? 0;

    if (unitsPerPackageStr.trim().isEmpty) return '$totalUnits Pcs';

    final unitsPerPackage = int.tryParse(unitsPerPackageStr) ?? 0;

    if (unitsPerPackage <= 0) return '$totalUnits Pcs';

    final fullPackages = totalUnits ~/ unitsPerPackage;
    final extraUnits = totalUnits % unitsPerPackage;

    return extraUnits == 0
        ? '($fullPackages×$unitsPerPackage)'
        : '($fullPackages×$unitsPerPackage+$extraUnits)';
  }
}
