import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/constants/enums.dart';
import 'package:trucky/core/constants/route_paths.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_bloc.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_event.dart';
import 'package:trucky/presentation/home/widgets/dashboard_header_widget.dart';
import 'package:trucky/presentation/home/widgets/dashboard_sheet_widget.dart';

/// Minimal placeholder screen so the app boots.
/// Replace with your real screens under `presentation/screens/`.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              width: double.infinity,
              height: 300.h,
              child: SvgPicture.asset(
                AppAssets.svgs.blueBackgroundSvg,
                fit: BoxFit.fill, // Try cover or fill
              ),
            ),
          ),
          Positioned(
            top: 80.h,
            left: 0,
            right: 0,
            child: HomeHeaderWidget(
              settingOnTap: () => context.push(RoutePaths.settings),
            ),
          ),
          Positioned(
            top: 170.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              child: DashBoardSheetWidget(
                onProductsTap: () => context.push(RoutePaths.products),
                onTreasuryTap: () => context.push(RoutePaths.treasury),
                onAnalysisTap: () => context.push(RoutePaths.analysis),
                onSalesTap: () {
                  context
                      .read<ClientSuppBloc>()
                      .add(const SetEntityTypeEvent(entityType: EntityType.client));
                  context.push(RoutePaths.salePurchase);
                },
                onPurchasesTap: () {
                  context
                      .read<ClientSuppBloc>()
                      .add(const SetEntityTypeEvent(entityType: EntityType.supplier));
                  context.push(RoutePaths.salePurchase);
                },
                onSuppliersTap: () {
                  context
                      .read<ClientSuppBloc>()
                      .add(const SetEntityTypeEvent(entityType: EntityType.supplier));
                  context.push(RoutePaths.suppliers);
                },
                onClientsTap: () {
                  context
                      .read<ClientSuppBloc>()
                      .add(const SetEntityTypeEvent(entityType: EntityType.client));
                  context.push(RoutePaths.clients);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
