import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/utils/number_formater.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/widgets/content_sheet.dart';
import 'package:trucky/presentation/widgets/custom_app_bar.dart';
import 'package:trucky/presentation/widgets/custom_scaffold.dart';
import 'package:trucky/presentation/widgets/scroll_aware_fab.dart';
import 'package:trucky/presentation/widgets/total_balance_widget.dart';

/// Common home view used by the Clients / Suppliers list screens.
class CommonHomeView extends StatelessWidget {
  final String pageTitle;
  final bool isBalanceVisible;
  final VoidCallback? onToggleBalance;
  final String balance;
  final Animation<double> scaleAnimation;
  final VoidCallback? fabOnTap;
  final bool showObsecureIcon;
  final bool showMenuIcon;
  final VoidCallback? filterIconOnTap;
  final VoidCallback? searchIconOnTap;
  final Widget? contentWidget;
  final FocusNode? focusNode;
  final TextEditingController? searchController;
  final bool showSearchField;
  final String sortType;
  final ValueChanged<String>? onChanged;

  const CommonHomeView({
    super.key,
    this.pageTitle = '',
    this.balance = '0',
    this.isBalanceVisible = true,
    this.onToggleBalance,
    this.fabOnTap,
    this.showObsecureIcon = false,
    this.showMenuIcon = false,
    this.filterIconOnTap,
    this.searchIconOnTap,
    this.contentWidget,
    this.focusNode,
    this.searchController,
    this.showSearchField = false,
    this.sortType = '',
    this.onChanged,
    required this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: pageTitle,
        leadingIconColor: Colors.white,
        titleColor: Colors.white,
        actionWidgets: [
          showObsecureIcon
              ? toggleBalanceWidget(isBalanceVisible, onToggleBalance)
              : const SizedBox.shrink(),
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
                buildTotalBalanceWidget(!isBalanceVisible, balance),
                Expanded(
                  child: ContentSheet(
                    contentWidget: contentWidget ?? const SizedBox.shrink(),
                    filterIconOnTap: filterIconOnTap ?? () {},
                    searchIconOnTap: searchIconOnTap ?? () {},
                    sortType: sortType,
                    showSearchField: showSearchField,
                    focusNode: focusNode,
                    controller: searchController,
                    onChanged: onChanged,
                  ).marginOnly(top: 40.h),
                ),
              ],
            ).marginOnly(top: 140.h),
          ],
        ),
      ),
      floatingActionButton: ScrollAwareFAB(
        onTap: fabOnTap ?? () {},
        scale: scaleAnimation,
      ),
    );
  }

  Widget buildTotalBalanceWidget(bool isVisible, String balance) {
    return TotalBalanceWidget(
      title: 'Total Balance',
      hideBalance: isVisible,
      balance: NumberFormater.formatAmount(
        balance,
        showCurrency: false,
        showAmount: isVisible,
      ),
    );
  }

  Widget toggleBalanceWidget(bool isVisible, VoidCallback? onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: GestureDetector(
        onTap: onTap,
        child: isVisible
            ? Image.asset(
                AppAssets.images.visibilityOn,
                height: 15.h,
                color: Colors.white,
              )
            : Image.asset(AppAssets.images.visibilityOff, height: 24.h),
      ),
    );
  }
}
