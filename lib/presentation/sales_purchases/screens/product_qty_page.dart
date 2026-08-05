import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/constants/font_constants.dart';
import 'package:trucky/core/constants/route_paths.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_bloc.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_event.dart';
import 'package:trucky/presentation/sales_purchases/widgets/quantity_control_widget.dart';
import 'package:trucky/presentation/widgets/custom_app_bar.dart';
import 'package:trucky/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:trucky/presentation/widgets/custom_elevated_button.dart';
import 'package:trucky/presentation/widgets/custom_scaffold.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// Sets the quantity / package count / unit price for one cart item.
class ProductQtyPage extends StatefulWidget {
  const ProductQtyPage({super.key});

  @override
  State<ProductQtyPage> createState() => _ProductQtyPageState();
}

class _ProductQtyPageState extends State<ProductQtyPage> {
  late final TextEditingController _quantityController;
  late final TextEditingController _qtyPerPkgController;
  late final TextEditingController _unitPriceController;

  @override
  void initState() {
    super.initState();
    final state = context.read<SalePurchaseBloc>().state;
    final item = state.editingItem ?? state.selectedProdList.first;

    _quantityController = TextEditingController(text: item.quantity.toString());
    _qtyPerPkgController = TextEditingController(
      text: item.quantityPerPackage ?? '',
    );
    _unitPriceController = TextEditingController(
      text: item.unitPrice.toString(),
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _qtyPerPkgController.dispose();
    _unitPriceController.dispose();
    super.dispose();
  }

  void _validate(BuildContext context) {
    final state = context.read<SalePurchaseBloc>().state;
    final item = state.editingItem ?? state.selectedProdList.first;

    context.read<SalePurchaseBloc>().add(
      SetCartItemDataEvent(
        productId: item.product.id ?? '',
        quantity:
            int.tryParse(
              _quantityController.text.isEmpty ? '1' : _quantityController.text,
            ) ??
            1,
        unitPrice: double.tryParse(_unitPriceController.text) ?? item.unitPrice,
        quantityPerPackage: _qtyPerPkgController.text,
      ),
    );

    if (state.editingItem != null || state.selectedProdList.length > 1) {
      context.pop();
    } else {
      context.push(RoutePaths.sellPurchaseCart);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalePurchaseBloc, dynamic>(
      builder: (context, _) {
        final state = context.read<SalePurchaseBloc>().state;
        final item = state.editingItem ?? state.selectedProdList.first;

        return CustomScaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: item.product.productName,
            titleColor: Colors.black,
            leadingIconColor: Colors.black,
          ),
          body: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppAssets.images.addProductIcon, height: 96.h),
                  20.verticalSpace,
                  LabelWidget(
                    text: 'Stock : ${item.product.availableStock} Pcs',
                    fontWeight: FontWeight.w700,
                    textSize: 24.sp,
                    fontFamily: FontConstants.interBold,
                  ),
                  30.verticalSpace,
                  LabelWidget(
                    text: 'Quantity of Units',
                    fontWeight: FontWeight.w600,
                    textSize: 14.sp,
                    textColor: const Color.fromRGBO(92, 97, 111, 1),
                  ),
                  10.verticalSpace,
                  QuantityControlWidget(
                    controller: _quantityController,
                    decQty: () {
                      final current =
                          int.tryParse(_quantityController.text) ?? 1;
                      if (current > 1) {
                        _quantityController.text = (current - 1).toString();
                      }
                    },
                    incQty: () {
                      final current =
                          int.tryParse(_quantityController.text) ?? 1;
                      if (current < item.product.availableStock) {
                        _quantityController.text = (current + 1).toString();
                      }
                    },
                  ),
                  30.verticalSpace,
                  if (!(item.quantityPerPackage?.isEmpty ?? false)) ...[
                    LabelWidget(
                      text: 'Quantity of Packages',
                      fontWeight: FontWeight.w600,
                      textSize: 14.sp,
                      textColor: const Color.fromRGBO(92, 97, 111, 1),
                    ),
                    QuantityControlWidget(
                      controller: _qtyPerPkgController,
                      decQty: () {
                        final current =
                            int.tryParse(_qtyPerPkgController.text) ?? 1;
                        if (current > 1) {
                          _qtyPerPkgController.text = (current - 1).toString();
                        }
                      },
                      incQty: () {
                        final current =
                            int.tryParse(_qtyPerPkgController.text) ?? 1;
                        _qtyPerPkgController.text = (current + 1).toString();
                      },
                    ),
                  ],
                  30.verticalSpace,
                  LabelWidget(
                    text: 'Unit Price',
                    fontWeight: FontWeight.w600,
                    textSize: 14.sp,
                    textColor: const Color.fromRGBO(92, 97, 111, 1),
                  ),
                  10.verticalSpace,
                  CustomNumberField(
                    controller: _unitPriceController,
                  ).paddingSymmetric(horizontal: 40.w),
                ],
              ),
            ),
          ),
          bottomNavigationBar: CustomBottomNavBarWidget(
            navBarColor: Colors.white,
            widget: CustomElevatedButton(
              btnTitle: 'Validate',
              onTap: () => _validate(context),
            ),
          ),
        );
      },
    );
  }
}
