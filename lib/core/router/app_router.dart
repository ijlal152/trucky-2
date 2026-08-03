import 'package:go_router/go_router.dart';
import 'package:trucky/core/constants/route_paths.dart';
import 'package:trucky/core/router/navigator_key.dart';
import 'package:trucky/presentation/client_supplier/screens/add_client_supp_screen.dart';
import 'package:trucky/presentation/client_supplier/screens/client_supp_dashboard_screen.dart';
import 'package:trucky/presentation/client_supplier/screens/client_supp_page.dart';
import 'package:trucky/presentation/home/screens/home_screen.dart';
import 'package:trucky/presentation/products/screens/add_product_screen.dart';
import 'package:trucky/presentation/products/screens/product_dashboard_screen.dart';
import 'package:trucky/presentation/products/screens/product_screen.dart';
import 'package:trucky/presentation/sales_purchases/screens/choose_client_supp_page.dart';
import 'package:trucky/presentation/sales_purchases/screens/choose_products_page.dart';
import 'package:trucky/presentation/sales_purchases/screens/invoice_page.dart';
import 'package:trucky/presentation/sales_purchases/screens/payment_details_page.dart';
import 'package:trucky/presentation/sales_purchases/screens/product_qty_page.dart';
import 'package:trucky/presentation/sales_purchases/screens/sale_purchase_page.dart';
import 'package:trucky/presentation/sales_purchases/screens/sell_purchase_cart_page.dart';
import 'package:trucky/presentation/sales_purchases/screens/set_discount_page.dart';
import 'package:trucky/presentation/splash/screens/splash_screen.dart';

/// App-level router configuration (composition root).
final appRouter = GoRouter(
  initialLocation: RoutePaths.splash,
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
      path: RoutePaths.splash,
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RoutePaths.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: RoutePaths.products,
      name: 'products',
      builder: (context, state) => const ProductScreen(),
    ),
    GoRoute(
      path: RoutePaths.addProduct,
      name: 'addProduct',
      builder: (context, state) => const AddProductScreen(),
    ),
    GoRoute(
      path: RoutePaths.productDashboard,
      name: 'productDashboard',
      builder: (context, state) => const ProductDashboardScreen(),
    ),
    GoRoute(
      path: RoutePaths.clients,
      name: 'clients',
      builder: (context, state) => const ClientSuppPage(),
    ),
    GoRoute(
      path: RoutePaths.suppliers,
      name: 'suppliers',
      builder: (context, state) => const ClientSuppPage(),
    ),
    GoRoute(
      path: RoutePaths.addClientSupp,
      name: 'addClientSupp',
      builder: (context, state) => const AddClientSuppScreen(),
    ),
    GoRoute(
      path: RoutePaths.clientSuppDashboard,
      name: 'clientSuppDashboard',
      builder: (context, state) => const ClientSuppDashboardScreen(),
    ),
    GoRoute(
      path: RoutePaths.salePurchase,
      name: 'salePurchase',
      builder: (context, state) => const SalePurchasePage(),
    ),
    GoRoute(
      path: RoutePaths.chooseClientSupp,
      name: 'chooseClientSupp',
      builder: (context, state) => const ChooseClientSuppPage(),
    ),
    GoRoute(
      path: RoutePaths.chooseProducts,
      name: 'chooseProducts',
      builder: (context, state) => const ChooseProductsPage(),
    ),
    GoRoute(
      path: RoutePaths.productQty,
      name: 'productQty',
      builder: (context, state) => const ProductQtyPage(),
    ),
    GoRoute(
      path: RoutePaths.sellPurchaseCart,
      name: 'sellPurchaseCart',
      builder: (context, state) => const SellPurchaseCartPage(),
    ),
    GoRoute(
      path: RoutePaths.setDiscount,
      name: 'setDiscount',
      builder: (context, state) => const SetDiscountPage(),
    ),
    GoRoute(
      path: RoutePaths.paymentDetails,
      name: 'paymentDetails',
      builder: (context, state) => const PaymentDetailsPage(),
    ),
    GoRoute(
      path: RoutePaths.invoice,
      name: 'invoice',
      builder: (context, state) => const InvoicePage(),
    ),
  ],
);
