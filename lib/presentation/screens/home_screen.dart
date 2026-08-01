import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/presentation/widgets/dashboard_header_widget.dart';
import 'package:trucky/presentation/widgets/dashboard_sheet_widget.dart';

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
            child: HomeHeaderWidget(settingOnTap: () {}),
          ),
          Positioned(
            top: 170.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment(0.00, -1.00),
                  end: Alignment(0, 1),
                  colors: [Color(0xFFE8EBF5), Color(0xFFFBFCFF)],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              child: DashBoardSheetWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
