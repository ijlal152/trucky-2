import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/constants/route_paths.dart';
import 'package:trucky/core/utils/number_formater.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/products/bloc/product_bloc.dart';
import 'package:trucky/presentation/products/bloc/product_event.dart';
import 'package:trucky/presentation/products/widgets/product_list.dart';
import 'package:trucky/presentation/widgets/content_sheet.dart';
import 'package:trucky/presentation/widgets/custom_app_bar.dart';
import 'package:trucky/presentation/widgets/custom_floating_btn.dart';
import 'package:trucky/presentation/widgets/custom_scaffold.dart';
import 'package:trucky/presentation/widgets/total_balance_widget.dart';

class ProductScreen extends StatefulWidget {
  static const String id = RoutePaths.products;

  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _dispatchLoad();
  }

  void _dispatchLoad() {
    // Dispatch after the first frame so BlocProvider is available.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !context.read<ProductBloc>().state.isLoaded) {
        context.read<ProductBloc>().add(const LoadProductsEvent());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ProductView(scrollController: _scrollController);
  }
}

class _ProductView extends StatelessWidget {
  const _ProductView({required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProductBloc>().state;
    final bloc = context.read<ProductBloc>();

    return CustomScaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        leadingIconColor: Colors.white,
        titleColor: Colors.white,
        title: 'Products',
        actionWidgets: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: GestureDetector(
              onTap: () =>
                  bloc.add(const ToggleProductBalanceVisibilityEvent()),
              child: state.hideProductTotalBalance
                  ? Image.asset(
                      AppAssets.images.visibilityOn,
                      height: 15.h,
                      color: Colors.white,
                    )
                  : Image.asset(AppAssets.images.visibilityOff, height: 24.h),
            ),
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
                TotalBalanceWidget(
                  title: 'Total Stock Value',
                  hideBalance: state.hideProductTotalBalance,
                  balance: NumberFormater.formatAmount(
                    state.totalStockValue.toString(),
                    showCurrency: false,
                    showAmount: state.hideProductTotalBalance,
                  ),
                ),
                40.verticalSpace,
                Expanded(
                  child: ContentSheet(
                    sortType: 'Old to new',
                    filterIconOnTap: () {},
                    searchIconOnTap: () {},
                    isBarCodeEnabled: true,
                    contentWidget: ProductList(
                      list: state.products,
                      showBalance: state.hideProductTotalBalance,
                      scrollController: scrollController,
                      onProductTap: (String productID) {
                        bloc.add(SelectProductEvent(id: productID));
                        context.push(RoutePaths.productDashboard);
                      },
                    ),
                  ),
                ),
              ],
            ).paddingOnly(top: 140.h),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingBtn(
        onTap: () => context.push(RoutePaths.addProduct),
      ),
    );
  }
}
