/// Central registry for route paths.
///
/// Keeping paths in one place avoids stringly-typed navigation and makes
/// the router easy to reason about.
abstract final class RoutePaths {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String products = '/products';
  static const String addProduct = '/products/add';
  static const String productDashboard = '/products/dashboard';
  static const String clients = '/clients';
  static const String suppliers = '/suppliers';
  static const String addClientSupp = '/clients-suppliers/add';
  static const String clientSuppDashboard = '/clients-suppliers/dashboard';
  static const String salePurchase = '/sale-purchase';
  static const String chooseClientSupp = '/sale-purchase/choose-client-supp';
  static const String chooseProducts = '/sale-purchase/choose-products';
  static const String productQty = '/sale-purchase/product-qty';
  static const String sellPurchaseCart = '/sale-purchase/cart';
  static const String setDiscount = '/sale-purchase/set-discount';
  static const String paymentDetails = '/sale-purchase/payment-details';
  static const String invoice = '/sale-purchase/invoice';
}
