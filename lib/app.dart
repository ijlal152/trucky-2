import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/constants/app_constants.dart';
import 'package:trucky/core/database/app_database.dart';
import 'package:trucky/core/router/app_router.dart';
import 'package:trucky/core/theme/app_theme.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_bloc.dart';
import 'package:trucky/presentation/analysis/bloc/analysis_bloc.dart';
import 'package:trucky/presentation/products/bloc/product_bloc.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_bloc.dart';
import 'package:trucky/presentation/settings/bloc/settings_bloc.dart';
import 'package:trucky/presentation/treasury/bloc/treasury_bloc.dart';

/// Root application widget.
class TruckyApp extends StatefulWidget {
  const TruckyApp({super.key});

  @override
  State<TruckyApp> createState() => _TruckyAppState();
}

class _TruckyAppState extends State<TruckyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AppDatabase.instance.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App is minimized, close the database.
      AppDatabase.instance.close();
    } else if (state == AppLifecycleState.resumed) {
      // App is reopened, ensure the database is open again.
      AppDatabase.instance.database;
    }
    super.didChangeAppLifecycleState(state);
  }

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
            BlocProvider(create: (_) => SalePurchaseBloc()),
            BlocProvider(create: (_) => SettingsBloc()),
            BlocProvider(create: (_) => TreasuryBloc()),
            BlocProvider(create: (_) => AnalysisBloc()),
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
