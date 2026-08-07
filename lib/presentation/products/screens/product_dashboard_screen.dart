import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/constants/route_paths.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/products/bloc/product_bloc.dart';
import 'package:trucky/presentation/products/bloc/product_event.dart';
import 'package:trucky/presentation/products/widgets/product_details_widget.dart';
import 'package:trucky/presentation/products/widgets/product_info_widget.dart';
import 'package:trucky/presentation/widgets/content_sheet.dart';
import 'package:trucky/presentation/widgets/custom_app_bar.dart';
import 'package:trucky/presentation/widgets/custom_scaffold.dart';

class ProductDashboardScreen extends StatelessWidget {
  static const String id = RoutePaths.productDashboard;

  const ProductDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ProductBloc>();
    // Narrow subscriptions so the dashboard only rebuilds when the rendered
    // fields change (the bloc is app-wide).
    final selectedProduct = context.select<ProductBloc, Product?>(
      (b) => b.state.selectedProduct,
    );
    final hideDashboardTotalBalance = context.select<ProductBloc, bool>(
      (b) => b.state.hideDashboardTotalBalance,
    );
    final productDetailsList = context.select<ProductBloc, List<ProductDetail>>(
      (b) => b.state.productDetailsList,
    );

    return CustomScaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        leadingIconColor: Colors.white,
        titleColor: Colors.white,
        title: selectedProduct?.productName ?? 'Product Details',
        actionWidgets: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: GestureDetector(
              onTap: () =>
                  bloc.add(const ToggleDashboardBalanceVisibilityEvent()),
              child: !hideDashboardTotalBalance
                  ? Image.asset(
                      AppAssets.images.visibilityOn,
                      height: 15.h,
                      color: Colors.white,
                    )
                  : Image.asset(AppAssets.images.visibilityOff, height: 24.h),
            ),
          ),
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 1,
                child: const Text('Edit'),
                onTap: () => context.push(RoutePaths.addProduct),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: const Text('Delete'),
                onTap: () {
                  final id = selectedProduct?.id;
                  if (id != null) {
                    bloc.add(RemoveProductEvent(id: id));
                    context.pop();
                  }
                },
              ),
            ],
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: SvgPicture.asset(
                AppAssets.svgs.blueBackgroundSvg,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (selectedProduct != null)
                  ProductInfoWidget(selectedProduct: selectedProduct),
                30.verticalSpace,
                Expanded(
                  child: ContentSheet(
                    filterIconOnTap: () {},
                    searchIconOnTap: () {},
                    contentWidget: ProductDetailsListWidget(
                      list: productDetailsList,
                    ),
                  ),
                ),
              ],
            ).paddingOnly(top: 110.h),
          ],
        ),
      ),
    );
  }
}
