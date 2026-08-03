import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/theme/app_colors.dart';
import 'package:trucky/core/utils/image_utils.dart';
import 'package:trucky/core/utils/number_formater.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/products/bloc/product_bloc.dart';
import 'package:trucky/presentation/widgets/custom_divider.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

class ProductList extends StatelessWidget {
  final List<Product> list;
  final bool showBalance;
  final ScrollController? scrollController;
  final void Function(int productID)? onProductTap;

  const ProductList({
    super.key,
    required this.list,
    required this.showBalance,
    this.scrollController,
    this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return list.isEmpty
        ? const Center(child: LabelWidget(text: 'No Product Found'))
        : ListView.separated(
            shrinkWrap: true,
            controller: scrollController,
            padding: EdgeInsets.zero,
            itemCount: list.length,
            itemBuilder: (context, index) {
              final product = list[index];
              return GestureDetector(
                onTap: () {
                  if (onProductTap != null) {
                    onProductTap!(product.id ?? -1);
                  }
                },
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 10.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            buildProductImage(
                              base64Image: product.productImage ?? '',
                            ),
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
                                        textColor:
                                            product.availableStock == 0
                                            ? const Color.fromRGBO(
                                                255,
                                                124,
                                                111,
                                                1,
                                              )
                                            : const Color.fromRGBO(
                                                0,
                                                177,
                                                103,
                                                1,
                                              ),
                                      ),
                                      LabelWidget(
                                        text: ' x ',
                                        textSize: 16.sp,
                                      ),
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
                              text: NumberFormater.formatAmount(
                                product.purchaseValue.toString(),
                                showAmount: showBalance,
                              ),
                              textSize: 16.sp,
                            ),
                            LabelWidget(
                              text: 'Purchase Value',
                              textSize: 14.sp,
                              fontWeight: FontWeight.w500,
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
}

Widget _buildImageWidget(
  Uint8List data,
  double? height,
  double? width,
  bool isRound,
) {
  final image = Image.memory(
    data,
    height: height ?? 48.h,
    width: width ?? 48.h,
    fit: BoxFit.cover,
  );

  return isRound
      ? ClipOval(child: image)
      : ClipRRect(borderRadius: BorderRadius.circular(10.r), child: image);
}

final Map<String, Uint8List> _base64ImageCache = {};

Widget buildProductImage({
  required String? base64Image,
  double? imgHeight,
  double? imgWidth,
  bool isRoundImg = true,
}) {
  if (base64Image == null || base64Image.isEmpty) {
    return Image.asset(
      AppAssets.images.productIcon,
      height: imgHeight ?? 48.h,
      width: imgWidth ?? 48.h,
    );
  }

  if (_base64ImageCache.containsKey(base64Image)) {
    return _buildImageWidget(
      _base64ImageCache[base64Image]!,
      imgHeight,
      imgWidth,
      isRoundImg,
    );
  }

  return FutureBuilder<Uint8List>(
    future: Future.delayed(const Duration(milliseconds: 100), () {
      final imageData = ImageUtils.convertBase64ToImage(img: base64Image);
      _base64ImageCache[base64Image] = imageData;
      return imageData;
    }),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return SizedBox(
          height: imgHeight ?? 48.h,
          width: imgWidth ?? 48.h,
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.buttonBgColor,
            ),
          ),
        );
      } else if (snapshot.hasError || snapshot.data == null) {
        return Icon(
          Icons.image_not_supported,
          size: imgHeight ?? 48.h,
          color: Colors.grey,
        );
      } else {
        return _buildImageWidget(
          snapshot.data!,
          imgHeight,
          imgWidth,
          isRoundImg,
        );
      }
    },
  );
}
