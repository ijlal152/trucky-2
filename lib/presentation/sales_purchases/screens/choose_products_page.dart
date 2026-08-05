import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/constants/enums.dart';
import 'package:trucky/core/constants/route_paths.dart';
import 'package:trucky/core/utils/number_formater.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/products/bloc/product_bloc.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_bloc.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_event.dart';
import 'package:trucky/presentation/widgets/custom_app_bar.dart';
import 'package:trucky/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:trucky/presentation/widgets/custom_divider.dart';
import 'package:trucky/presentation/widgets/custom_elevated_button.dart';
import 'package:trucky/presentation/widgets/custom_scaffold.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// Step 2 of a sale/purchase: pick products for the cart.
class ChooseProductsPage extends StatelessWidget {
  const ChooseProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, dynamic>(
      builder: (context, _) {
        final products = context.read<ProductBloc>().state.products;
        final entityType = context.read<SalePurchaseBloc>().state.entityType;
        final isClient = entityType == EntityType.client;
        final priceTitle = isClient ? 'Selling Price : ' : 'Purchase Price : ';

        return CustomScaffold(
          appBar: CustomAppBar(
            title: '(${products.length}) Products',
            titleColor: Colors.black,
            leadingIconColor: Colors.black,
            actionWidgets: [
              Image.asset(AppAssets.images.barCodeScanner, height: 30.h),
              Image.asset(
                AppAssets.images.searchIcon,
                height: 24.h,
                width: 24.w,
              ).paddingSymmetric(horizontal: 15.w),
            ],
          ),
          body: SizedBox(
            width: double.infinity,
            child: products.isEmpty
                ? const Center(child: LabelWidget(text: 'No Product Found'))
                : Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(32),
                            ),
                          ),
                          child: BlocBuilder<SalePurchaseBloc, dynamic>(
                            builder: (context, _) {
                              final state = context
                                  .read<SalePurchaseBloc>()
                                  .state;
                              return ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  final availableStock = product.availableStock;
                                  final outOfStock = availableStock <= 0;
                                  final added = state.isInCart(
                                    product.id ?? '',
                                  );
                                  final price = isClient
                                      ? product.sellingPrice
                                      : product.purchasePrice;
                                  return InkWell(
                                    onTap: () =>
                                        context.read<SalePurchaseBloc>().add(
                                          ToggleProductEvent(product: product),
                                        ),
                                    child: Container(
                                      color: Colors.transparent,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15.w,
                                        vertical: 10.h,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: 48.h,
                                                width: 48.h,
                                                decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(
                                                    246,
                                                    247,
                                                    248,
                                                    1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        12.r,
                                                      ),
                                                ),
                                                child: Icon(
                                                  Icons.inventory_2_outlined,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                              8.horizontalSpace,
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  LabelWidget(
                                                    text: product.productName,
                                                    textColor: Colors.black,
                                                    textSize: 17.sp,
                                                  ),
                                                  5.verticalSpace,
                                                  Row(
                                                    children: [
                                                      LabelWidget(
                                                        text: priceTitle,
                                                        textColor:
                                                            const Color.fromRGBO(
                                                              92,
                                                              97,
                                                              111,
                                                              1,
                                                            ),
                                                        textSize: 17.sp,
                                                      ),
                                                      LabelWidget(
                                                        text:
                                                            NumberFormater.formatAmount(
                                                              price.toString(),
                                                              showCurrency:
                                                                  true,
                                                            ),
                                                        textSize: 17.sp,
                                                        textColor: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      LabelWidget(
                                                        text: 'Stock : ',
                                                        textColor:
                                                            const Color.fromRGBO(
                                                              92,
                                                              97,
                                                              111,
                                                              1,
                                                            ),
                                                        textSize: 17.sp,
                                                      ),
                                                      LabelWidget(
                                                        text: availableStock
                                                            .toString(),
                                                        textSize: 17.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        textColor: outOfStock
                                                            ? Colors.red
                                                            : const Color.fromRGBO(
                                                                0,
                                                                177,
                                                                103,
                                                                1,
                                                              ),
                                                      ),
                                                      LabelWidget(
                                                        text: 'Pcs',
                                                        textColor: outOfStock
                                                            ? Colors.red
                                                            : const Color.fromRGBO(
                                                                0,
                                                                177,
                                                                103,
                                                                1,
                                                              ),
                                                        textSize: 17.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ).paddingSymmetric(
                                                        horizontal: 3.w,
                                                      ),
                                                      if (outOfStock)
                                                        LabelWidget(
                                                          text:
                                                              '(Out of Stock)',
                                                          textColor: Colors.red,
                                                          textSize: 17.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ).paddingSymmetric(
                                                          horizontal: 3.w,
                                                        ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          added
                                              ? Image.asset(
                                                  AppAssets
                                                      .images
                                                      .checkIconGreen,
                                                  height: 12.h,
                                                )
                                              : const SizedBox.shrink(),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15.w,
                                  ),
                                  child: dividerWidget(),
                                ),
                              ).paddingOnly(top: 10.h);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          bottomNavigationBar: CustomBottomNavBarWidget(
            navBarColor: Colors.white,
            widget: BlocBuilder<SalePurchaseBloc, dynamic>(
              builder: (context, _) {
                final state = context.read<SalePurchaseBloc>().state;
                return CustomElevatedButton(
                  isDisabled: state.selectedProdList.isEmpty,
                  btnTitle: 'View Cart (${state.selectedProdList.length})',
                  onTap: () {
                    if (state.selectedProdList.length > 1) {
                      context.push(RoutePaths.sellPurchaseCart);
                    } else {
                      context.push(RoutePaths.productQty);
                    }
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
