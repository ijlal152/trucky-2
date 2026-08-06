import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/constants/app_constants.dart';
import 'package:trucky/core/constants/font_constants.dart';
import 'package:trucky/core/constants/route_paths.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_bloc.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_event.dart';
import 'package:trucky/presentation/products/bloc/product_bloc.dart';
import 'package:trucky/presentation/products/bloc/product_event.dart';
import 'package:trucky/presentation/widgets/horizontal_loader.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Preload all data so the home dashboard shows live counts immediately.
      context.read<ProductBloc>().add(const LoadProductsEvent());
      context.read<ClientSuppBloc>().add(const LoadClientSuppEvent());
    });
    _timer = Timer(const Duration(seconds: 3), _navigateHome);
  }

  void _navigateHome() {
    if (!mounted) return;
    context.go(RoutePaths.home);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
