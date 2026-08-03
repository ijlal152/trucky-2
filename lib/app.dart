import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/constants/app_constants.dart';
import 'package:trucky/core/router/app_router.dart';
import 'package:trucky/core/theme/app_theme.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_bloc.dart';
import 'package:trucky/presentation/products/bloc/product_bloc.dart';

/// Root application widget.
class TruckyApp extends StatelessWidget {
  const TruckyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 892),
      minTextAdapt: true,
      fontSizeResolver: FontSizeResolvers.height,
      useInheritedMediaQuery: false,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: const TextScaler.linear(1)),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ProductBloc()),
            BlocProvider(create: (_) => ClientSuppBloc()),
          ],
          child: MaterialApp.router(
            title: AppConstants.appName,
            theme: AppTheme.light,
            routerConfig: appRouter,
            debugShowCheckedModeBanner: false,
          ),
        ),
      ),
    );
  }
}
