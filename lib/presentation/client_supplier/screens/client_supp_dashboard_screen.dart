import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/constants/constants.dart';
import 'package:trucky/core/constants/enums.dart';
import 'package:trucky/core/constants/route_paths.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_bloc.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_event.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_models.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_state.dart';
import 'package:trucky/presentation/client_supplier/widgets/client_supp_common_dashboard_view.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_bloc.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_event.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_models.dart';
import 'package:trucky/presentation/sales_purchases/mixins/transaction_edit_mixin.dart';
import 'package:trucky/presentation/widgets/bottom_sheet_payment_type_items.dart';
import 'package:trucky/presentation/widgets/custom_bottom_sheet.dart';
import 'package:trucky/presentation/widgets/custom_fab_controller.dart';
import 'package:trucky/presentation/widgets/scroll_aware_fab.dart';

/// Client / Supplier dashboard (details + transactions).
class ClientSuppDashboardScreen extends StatefulWidget {
  const ClientSuppDashboardScreen({super.key});

  @override
  State<ClientSuppDashboardScreen> createState() =>
      _ClientSuppDashboardScreenState();
}

class _ClientSuppDashboardScreenState extends State<ClientSuppDashboardScreen>
    with SingleTickerProviderStateMixin, TransactionEditMixin {
  late final CustomFabController fabCont;

  @override
  void initState() {
    super.initState();
    fabCont = CustomFabController(this);
  }

  @override
  void dispose() {
    fabCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientSuppBloc, ClientSuppState>(
      builder: (context, state) {
        final bloc = context.read<ClientSuppBloc>();
        final selected = state.selectedCS;
        final isClient = state.entityType == EntityType.client;

        return ClientSuppCommonDashboardView(
          selectedEntity: selected,
          list: state.selectedCSTxns,
          scrollController: fabCont.scrollController,
          paymentTypes: isClient
              ? Constants.clientPaymentTypeSelector
              : Constants.supplierPaymentTypeSelector,
          selectedPaymentTypeIndex: state.selectedIndex,
          onSelectedPaymentType: (index) {
            bloc.add(FilterTxnsByPaymentTypeEvent(index: index));
          },
          onEdit: () {},
          onDelete: () {},
          onLocationPressed: (lat, lng) {},
          iconBuilder: (index, item) => _iconBasedOnPaymentType(item, isClient),
          amountColorBuilder: (index, item) => _amountColor(item, isClient),
          onTapTxn: (index) {
            final txn = state.selectedCSTxns[index];
            onTapToEdit(context, txn, returnToDashboard: true);
          },
          totalBalance: state.selectedCSTxns.isEmpty
              ? '0'
              : ClientSuppTxn.calculateBalanceAtIndex(
                  transactions: state.selectedCSTxns,
                  index: 0,
                ).toString(),
          floatingActionButton: ScrollAwareFAB(
            onTap: () =>
                _openTransactionSheet(context, bloc, selected, isClient),
            scale: fabCont.scaleAnimation,
          ),
        );
      },
    );
  }

  void _openTransactionSheet(
    BuildContext context,
    ClientSuppBloc bloc,
    ClientSupp? selected,
    bool isClient,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => CustomBottomSheetContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Wrap(
              spacing: 40,
              children: [
                btmSheetPaymentTypeItem(
                  icon: isClient
                      ? AppAssets.images.sellsIcon
                      : AppAssets.images.supplierIcon,
                  itemName: isClient ? 'Sale' : 'Purchase',
                  onTap: () => _navigateToSalePurchase(context, bloc),
                ),
                btmSheetPaymentTypeItem(
                  icon: AppAssets.images.paymentIcon,
                  itemName: 'Payment',
                  onTap: () => _navigateToPayment(context, bloc, selected),
                ),
                btmSheetPaymentTypeItem(
                  icon: AppAssets.images.returnIcon,
                  itemName: 'Return',
                  onTap: () => _navigateToReturn(context, bloc),
                ),
                btmSheetPaymentTypeItem(
                  icon: AppAssets.images.negativeRefundIcon,
                  itemName: 'Refund',
                  onTap: () => _navigateToRefund(context, bloc, selected),
                ),
              ],
            ).paddingSymmetric(vertical: 30.h),
          ],
        ),
      ),
    );
  }

  void _navigateToSalePurchase(BuildContext context, ClientSuppBloc bloc) {
    final entityType = bloc.state.entityType;
    context.read<SalePurchaseBloc>().add(
      InitSalePurchaseEvent(
        entityType: entityType,
        transactionType: TransactionType.sale,
      ),
    );
    Navigator.pop(context);
    context.push(RoutePaths.chooseClientSupp);
  }

  void _navigateToReturn(BuildContext context, ClientSuppBloc bloc) {
    final entityType = bloc.state.entityType;
    context.read<SalePurchaseBloc>().add(
      InitSalePurchaseEvent(
        entityType: entityType,
        transactionType: TransactionType.returnTransaction,
      ),
    );
    Navigator.pop(context);
    context.push(RoutePaths.chooseClientSupp);
  }

  void _navigateToPayment(
    BuildContext context,
    ClientSuppBloc bloc,
    ClientSupp? selected,
  ) {
    final currentBalance = _calculateBalance(bloc);
    final paymentData = PaymentDataModel.directPayment(
      clientSupplier: selected,
      oldBalance: currentBalance,
    );
    Navigator.pop(context);
    context.push(RoutePaths.paymentDetails, extra: paymentData);
  }

  void _navigateToRefund(
    BuildContext context,
    ClientSuppBloc bloc,
    ClientSupp? selected,
  ) {
    final currentBalance = _calculateBalance(bloc);
    final paymentData = PaymentDataModel.refund(
      clientSupplier: selected,
      oldBalance: currentBalance,
    );
    Navigator.pop(context);
    context.push(RoutePaths.paymentDetails, extra: paymentData);
  }

  double _calculateBalance(ClientSuppBloc bloc) {
    final txns = bloc.state.selectedCSTxns;
    if (txns.isEmpty) return 0;
    return ClientSuppTxn.calculateBalanceAtIndex(transactions: txns, index: 0);
  }

  Widget _iconBasedOnPaymentType(ClientSuppTxn transaction, bool isClient) {
    const double iconSize = 42;
    final Map<String, String> paymentTypeIcons = isClient
        ? {
            'Initial Balance': AppAssets.images.sellsIcon,
            'Sale': AppAssets.images.sellsIcon,
            'Payment': AppAssets.images.paymentIcon,
            'Return': AppAssets.images.returnIcon,
            'Refund': AppAssets.images.negativeRefundIcon,
          }
        : {
            'Initial Balance': AppAssets.images.supplierIcon,
            'Purchase': AppAssets.images.supplierIcon,
            'Payment': AppAssets.images.negativePaymentIcon,
            'Return': AppAssets.images.returnIcon,
            'Refund': AppAssets.images.positiveRefundIcon,
          };

    final String? iconPath = paymentTypeIcons[transaction.paymentType];
    if (iconPath != null) {
      return Image.asset(iconPath, height: iconSize.h, width: iconSize.h);
    }
    return const SizedBox.shrink();
  }

  Color _amountColor(ClientSuppTxn transaction, bool isClient) {
    if (isClient) {
      const Map<String, Color> paymentTypeColors = {
        'Initial Balance': Color.fromRGBO(255, 124, 111, 1),
        'Sale': Color.fromRGBO(255, 124, 111, 1),
        'Payment': Color.fromRGBO(0, 177, 103, 1),
        'Return': Color.fromRGBO(43, 136, 216, 1),
      };
      return paymentTypeColors[transaction.paymentType] ??
          const Color.fromRGBO(43, 136, 216, 1);
    } else {
      const Map<String, Color> paymentTypeColors = {
        'Initial Balance': Color.fromRGBO(0, 177, 103, 1),
        'Sale': Color.fromRGBO(255, 124, 111, 1),
        'Payment': Color.fromRGBO(255, 124, 111, 1),
        'Return': Color.fromRGBO(43, 136, 216, 1),
        'Purchase': Color.fromRGBO(0, 177, 103, 1),
        'Refund': Color.fromRGBO(0, 177, 103, 1),
      };
      return paymentTypeColors[transaction.paymentType] ??
          const Color.fromRGBO(43, 136, 216, 1);
    }
  }
}
