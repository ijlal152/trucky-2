import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/constants/app_constants.dart';
import 'package:trucky/core/constants/font_constants.dart';
import 'package:trucky/core/constants/route_paths.dart';
import 'package:trucky/presentation/widgets/horizontal_loader.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      context.go(RoutePaths.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(AppAssets.svgs.blueBackgroundSvg, fit: BoxFit.fill),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppConstants.appName,
                  style: TextStyle(
                    fontSize: 48.sp,
                    color: Colors.white,
                    fontFamily: FontConstants.interBold,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Your business, simplified',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white70,
                    fontFamily: FontConstants.inter,
                  ),
                ),
                SizedBox(height: 32.h),
                SizedBox(
                  width: 120.w,
                  child: const HorizontalLoader(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
