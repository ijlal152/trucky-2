import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/utils/number_formater.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/products/bloc/product_models.dart';
import 'package:trucky/presentation/products/widgets/product_image.dart';
import 'package:trucky/presentation/widgets/custom_divider.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

class ProductList extends StatelessWidget {
  final List<Product> list;
  final bool showBalance;
  final ScrollController? scrollController;
  final void Function(String productID)? onProductTap;

  const ProductList({
    super.key,
    required this.list,
    required this.showBalance,
    this.scrollController,
    this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const Center(child: LabelWidget(text: 'No Product Found'));
    }

    return ListView.separated(
      shrinkWrap: true,
      controller: scrollController,
      padding: EdgeInsets.zero,
      itemCount: list.length,
      itemBuilder: (context, index) {
        return _ProductListItem(
          product: list[index],
          showBalance: showBalance,
          onTap: onProductTap,
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
}

class _ProductListItem extends StatelessWidget {
  final Product product;
  final bool showBalance;
  final void Function(String productID)? onTap;

  const _ProductListItem({
    required this.product,
    required this.showBalance,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final id = product.id;
        if (onTap != null && id != null) {
          onTap!(id);
        }
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProductIdentity(product: product),
            _PurchaseValueBadge(
              value: product.purchaseValue,
              showBalance: showBalance,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductIdentity extends StatelessWidget {
  final Product product;

  const _ProductIdentity({required this.product});

  static const Color _outOfStockColor = Color.fromRGBO(255, 124, 111, 1);
  static const Color _inStockColor = Color.fromRGBO(0, 177, 103, 1);
  static const Color _priceColor = Color.fromRGBO(92, 97, 111, 1);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildProductImage(base64Image: product.productImage ?? ''),
        10.horizontalSpace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 200.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  LabelWidget(
                    text: product.availableStock.toString(),
                    textSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    textColor: product.availableStock == 0
                        ? _outOfStockColor
                        : _inStockColor,
                  ),
                  const LabelWidget(text: ' x ', textSize: 16),
                  Flexible(
                    child: LabelWidget(
                      text: product.productName,
                      textSize: 16.sp,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            LabelWidget(
              text:
                  'Price: ${NumberFormater.formatStringToCurrency(product.sellingPrice.toString())}',
              textSize: 14.sp,
              fontWeight: FontWeight.w500,
              textColor: _priceColor,
            ),
          ],
        ),
      ],
    );
  }
}

class _PurchaseValueBadge extends StatelessWidget {
  final double value;
  final bool showBalance;

  const _PurchaseValueBadge({required this.value, required this.showBalance});

  static const Color _labelColor = Color.fromRGBO(92, 97, 111, 1);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        LabelWidget(
          text: NumberFormater.formatAmount(
            value.toString(),
            showAmount: showBalance,
          ),
          textSize: 16.sp,
        ),
        const LabelWidget(
          text: 'Purchase Value',
          textSize: 14,
          fontWeight: FontWeight.w500,
          textColor: _labelColor,
        ),
      ],
    );
  }
}
