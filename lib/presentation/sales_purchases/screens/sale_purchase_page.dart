import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/constants/constants.dart';
import 'package:trucky/core/constants/enums.dart';
import 'package:trucky/core/constants/route_paths.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_bloc.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_bloc.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_event.dart';
import 'package:trucky/presentation/sales_purchases/mixins/transaction_edit_mixin.dart';
import 'package:trucky/presentation/sales_purchases/widgets/sale_purchase_common_list.dart';
import 'package:trucky/presentation/widgets/bottom_sheet_payment_type_items.dart';
import 'package:trucky/presentation/widgets/content_sheet.dart';
import 'package:trucky/presentation/widgets/custom_app_bar.dart';
import 'package:trucky/presentation/widgets/custom_bottom_sheet.dart';
import 'package:trucky/presentation/widgets/custom_fab_controller.dart';
import 'package:trucky/presentation/widgets/custom_scaffold.dart';
import 'package:trucky/presentation/widgets/payment_type_selector.dart';
import 'package:trucky/presentation/widgets/scroll_aware_fab.dart';

/// Lists recent Sales (clients) or Purchases (suppliers) and starts a new
/// transaction via the floating action button.
class SalePurchasePage extends StatefulWidget {
  const SalePurchasePage({super.key});

  @override
  State<SalePurchasePage> createState() => _SalePurchasePageState();
}

class _SalePurchasePageState extends State<SalePurchasePage>
    with SingleTickerProviderStateMixin, TransactionEditMixin {
  late final CustomFabController fabCont;

  @override
  void initState() {
    super.initState();
    fabCont = CustomFabController(this);
    final entityType = context.read<ClientSuppBloc>().state.entityType;
    context.read<SalePurchaseBloc>().add(
      InitSalePurchaseEvent(entityType: entityType),
    );
  }

  @override
  void dispose() {
    fabCont.dispose();
    super.dispose();
  }

  void _openTransactionSheet() {
    final entityType = context.read<ClientSuppBloc>().state.entityType;
    final isClient = entityType == EntityType.client;
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => CustomBottomSheetContent(
        child: Wrap(
          spacing: 70,
          children: [
            btmSheetPaymentTypeItem(
              icon: isClient
                  ? AppAssets.images.sellsIcon
                  : AppAssets.images.supplierIcon,
              itemName: isClient ? 'Sale' : 'Purchase',
              onTap: () {
                context.read<SalePurchaseBloc>().add(
                  InitSalePurchaseEvent(
                    entityType: entityType,
                    transactionType: TransactionType.sale,
                  ),
                );
                Navigator.pop(sheetContext);
                context.push(RoutePaths.chooseClientSupp);
              },
            ),
            btmSheetPaymentTypeItem(
              icon: AppAssets.images.returnIcon,
              itemName: 'Return',
              onTap: () {
                context.read<SalePurchaseBloc>().add(
                  InitSalePurchaseEvent(
                    entityType: entityType,
                    transactionType: TransactionType.returnTransaction,
                  ),
                );
                Navigator.pop(sheetContext);
                context.push(RoutePaths.chooseClientSupp);
              },
            ),
          ],
        ).paddingSymmetric(vertical: 20.h),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientSuppBloc, dynamic>(
      builder: (context, _) {
        final entityType = context.read<ClientSuppBloc>().state.entityType;
        final isClient = entityType == EntityType.client;
        final txns = context.read<ClientSuppBloc>().state.salePurchaseTxns;

        return CustomScaffold(
          extendBodyBehindAppBar: true,
          appBar: CustomAppBar(
            title: isClient ? 'Sales' : 'Purchases',
            titleColor: Colors.white,
            leadingIconColor: Colors.white,
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
                    Expanded(
                      child: ContentSheet(
                        sortType: 'Old to new',
                        filterIconOnTap: () {},
                        searchIconOnTap: () {},
                        contentWidget: Column(
                          children: [
                            PaymentTypeSelector(
                              paymentTypes: isClient
                                  ? Constants.salesPmtSelector
                                  : Constants.purchasePmtSelector,
                              selectedIndex: 0,
                              onSelected: (index) {},
                            ).paddingOnly(top: 20.h),
                            Expanded(
                              child: SalesPurchaseCommonList(
                                list: txns,
                                onTap: (index) =>
                                    onTapToEdit(context, txns[index]),
                              ),
                            ),
                          ],
                        ),
                      ).paddingOnly(top: 120.h),
                    ),
                  ],
                ),
              ],
            ),
          ),
          floatingActionButton: ScrollAwareFAB(
            onTap: _openTransactionSheet,
            scale: fabCont.scaleAnimation,
          ),
        );
      },
    );
  }
}
