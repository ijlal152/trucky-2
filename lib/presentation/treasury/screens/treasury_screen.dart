import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/constants/route_paths.dart';
import 'package:trucky/core/utils/number_formater.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/treasury/bloc/treasury_bloc.dart';
import 'package:trucky/presentation/treasury/bloc/treasury_event.dart';
import 'package:trucky/presentation/treasury/bloc/treasury_state.dart';
import 'package:trucky/presentation/treasury/widgets/treasury_list_widget.dart';
import 'package:trucky/presentation/widgets/content_sheet.dart';
import 'package:trucky/presentation/widgets/custom_app_bar.dart';
import 'package:trucky/presentation/widgets/custom_floating_btn.dart';
import 'package:trucky/presentation/widgets/custom_scaffold.dart';
import 'package:trucky/presentation/widgets/total_balance_widget.dart';

/// Treasury screen: shows the running cash-flow balance and entries.
class TreasuryScreen extends StatefulWidget {
  const TreasuryScreen({super.key});

  @override
  State<TreasuryScreen> createState() => _TreasuryScreenState();
}

class _TreasuryScreenState extends State<TreasuryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final bloc = context.read<TreasuryBloc>();
      if (bloc.state.treasuryList.isEmpty) {
        bloc.add(const LoadTreasuryEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TreasuryBloc, TreasuryState>(
      builder: (context, state) {
        return CustomScaffold(
          extendBodyBehindAppBar: true,
          appBar: CustomAppBar(
            title: 'Treasury',
            leadingIconColor: Colors.white,
            titleColor: Colors.white,
            actionWidgets: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: GestureDetector(
                  onTap: () => context
                      .read<TreasuryBloc>()
                      .add(const ToggleBalanceVisibilityEvent()),
                  child: state.isBalanceVisible
                      ? Image.asset(
                          AppAssets.images.visibilityOn,
                          height: 15.h,
                          color: Colors.white,
                        )
                      : Image.asset(
                          AppAssets.images.visibilityOff,
                          height: 24.h,
                        ),
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
                      title: 'Total Balance',
                      hideBalance: !state.isBalanceVisible,
                      balance: NumberFormater.formatStringToCurrency(
                        state.totalBalance.toString(),
                      ),
                    ),
                    40.verticalSpace,
                    Expanded(
                      child: ContentSheet(
                        filterIconOnTap: () {},
                        searchIconOnTap: () {},
                        contentWidget:
                            TreasuryListWidget(list: state.treasuryList),
                      ),
                    ),
                  ],
                ).paddingOnly(top: 140.h),
              ],
            ),
          ),
          floatingActionButton: CustomFloatingBtn(
            onTap: () => context.push(RoutePaths.addPaymentFromClient),
          ),
        );
      },
    );
  }
}