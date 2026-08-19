import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/constants/constants.dart';
import 'package:trucky/core/utils/number_formater.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_models.dart';
import 'package:trucky/presentation/client_supplier/widgets/client_supplier_contact_options.dart';
import 'package:trucky/presentation/client_supplier/widgets/transaction_list_widget.dart';
import 'package:trucky/presentation/widgets/content_sheet.dart';
import 'package:trucky/presentation/widgets/custom_app_bar.dart';
import 'package:trucky/presentation/widgets/custom_scaffold.dart';
import 'package:trucky/presentation/widgets/payment_type_selector.dart';
import 'package:trucky/presentation/widgets/total_balance_widget.dart';

/// Shared dashboard layout for a selected client/supplier.
class ClientSuppCommonDashboardView extends StatelessWidget {
  final PopInvokedWithResultCallback? onPopInvokedWithResult;
  final String totalBalance;
  final List<ClientSuppTxn> list;
  final ScrollController? scrollController;
  final ClientSupp? selectedEntity;
  final List<PaymentTypeSelectorModel> paymentTypes;
  final void Function(int)? onSelectedPaymentType;
  final int selectedPaymentTypeIndex;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final void Function(double, double)? onLocationPressed;
  final Widget? floatingActionButton;
  final Widget Function(int index, ClientSuppTxn item)? iconBuilder;
  final Color Function(int index, ClientSuppTxn item)? amountColorBuilder;
  final void Function(int index)? onTapTxn;

  const ClientSuppCommonDashboardView({
    super.key,
    this.onPopInvokedWithResult,
    this.totalBalance = '0',
    this.scrollController,
    this.selectedEntity,
    this.paymentTypes = const [],
    this.onSelectedPaymentType,
    this.selectedPaymentTypeIndex = 0,
    this.onEdit,
    this.onDelete,
    this.onLocationPressed,
    this.floatingActionButton,
    this.iconBuilder,
    this.amountColorBuilder,
    this.onTapTxn,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: CustomScaffold(
        extendBodyBehindAppBar: true,
        appBar: CustomAppBar(
          title: selectedEntity?.name ?? '',
          leadingIconColor: Colors.white,
          titleColor: Colors.white,
          actionWidgets: [
            PopupMenuButton<int>(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  onTap: onEdit ?? () {},
                  child: const Text('Edit'),
                ),
                PopupMenuItem(
                  value: 2,
                  onTap: onDelete ?? () {},
                  child: const Text('Delete'),
                ),
              ],
              offset: const Offset(0, 50),
              color: Colors.white,
              elevation: 5,
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
                    title: 'Balance',
                    balance: NumberFormater.formatAmount(totalBalance),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned(
                          top: 80.h,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: ContentSheet(
                            filterIconOnTap: () {},
                            searchIconOnTap: () {},
                            isSortFeatureEnabled: false,
                            contentWidget: Container(),
                          ),
                        ),
                        Positioned(
                          top: 25.h,
                          right: 0,
                          left: 0,
                          bottom: 0,
                          child: Column(
                            children: [
                              ContactOptionsWidget(
                                phoneNumber: selectedEntity?.phoneNumber,
                                gpsLocation: selectedEntity?.gpsLocation,
                                onLocationPressed:
                                    onLocationPressed ?? (_, _) {},
                                noPhoneError:
                                    'No client phone number available!',
                                noGpsError: 'No client location available!',
                              ),
                              30.verticalSpace,
                              PaymentTypeSelector(
                                paymentTypes: paymentTypes,
                                selectedIndex: selectedPaymentTypeIndex,
                                onSelected: (index) =>
                                    onSelectedPaymentType?.call(index),
                              ),
                              10.verticalSpace,
                              Expanded(
                                child: TransactionListWidget<ClientSuppTxn>(
                                  list: list,
                                  scrollController: scrollController,
                                  iconBuilder:
                                      iconBuilder ??
                                      (index, item) => const SizedBox.shrink(),
                                  amountColorBuilder:
                                      amountColorBuilder ??
                                      (index, item) => const Color(0xFF2ECC71),
                                  onTapTxn: onTapTxn,
                                ).paddingOnly(bottom: 30.h),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ).paddingOnly(top: 130.h),
            ],
          ),
        ),
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
