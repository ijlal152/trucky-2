import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/constants/route_paths.dart';
import 'package:trucky/core/utils/extensions.dart';
import 'package:trucky/core/utils/number_formater.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_bloc.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_event.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_models.dart';
import 'package:trucky/presentation/widgets/custom_divider.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// The expandable cart line items.
class CartList extends StatelessWidget {
  const CartList({super.key, required this.cartItems});

  final List<CartItem> cartItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _sellingCartHeader(),
          Flexible(
            child: BlocBuilder<SalePurchaseBloc, dynamic>(
              builder: (context, _) {
                final state = context.read<SalePurchaseBloc>().state;
                return ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    final isExpanded = state.selectedTileIndex == index;
                    return Column(
                      children: [
                        InkWell(
                          onTap: () => context
                              .read<SalePurchaseBloc>()
                              .add(ToggleCartExpansionEvent(
                                index: index,
                                expanded: !isExpanded,
                              )),
                          child: ListTile(
                            leading: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: item.quantity.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const TextSpan(text: ' '),
                                  const TextSpan(
                                    text: 'X',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Color.fromRGBO(92, 97, 111, 1),
                                    ),
                                  ),
                                ],
                              ),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
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
                              fontWeight: FontWeight.w700,
                              textSize: 16.sp,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          child: isExpanded
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _editDeleteWidget(
                                      () {
                                        context
                                            .read<SalePurchaseBloc>()
                                            .add(SetEditingItemEvent(item));
                                        context.push(RoutePaths.productQty);
                                      },
                                      AppAssets.svgs.editIcon,
                                      'Edit',
                                      null,
                                    ),
                                    100.horizontalSpace,
                                    _editDeleteWidget(
                                      () => _confirmRemove(
                                        context,
                                        item,
                                      ),
                                      AppAssets.svgs.trashIcon,
                                      'Delete',
                                      const Color.fromRGBO(255, 124, 111, 1),
                                    ),
                                  ],
                                ).paddingOnly(top: 8.h)
                              : const SizedBox.shrink(),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: dividerWidget(),
                  ),
                ).paddingSymmetric(vertical: 10.h);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _confirmRemove(BuildContext context, CartItem item) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Warning!'),
        content: const Text('Do you really want to remove this product ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context
                  .read<SalePurchaseBloc>()
                  .add(RemoveCartItemEvent(productId: item.product.id ?? -1));
              Navigator.pop(dialogContext);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Widget _sellingCartHeader() {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(246, 247, 248, 1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LabelWidget(
            text: 'N° YY/001',
            textColor: const Color.fromRGBO(54, 61, 78, 1),
            fontWeight: FontWeight.w600,
            textSize: 16.sp,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          LabelWidget(
            text: DateTime.now().showMonthNameWithTime(false),
            textColor: const Color.fromRGBO(54, 61, 78, 1),
            fontWeight: FontWeight.w600,
            textSize: 16.sp,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _editDeleteWidget(
    VoidCallback? onTap,
    String image,
    String title,
    Color? textColor,
  ) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(image),
          5.verticalSpace,
          LabelWidget(
            text: title,
            textColor: textColor ?? Colors.black,
            fontWeight: FontWeight.w500,
            textSize: 16.sp,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
