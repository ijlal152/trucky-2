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
  static const String settings = '/settings';
  static const String personalInformation = '/settings/personal-information';
  static const String editPersonalInfo = '/settings/edit-personal-info';
  static const String editPassword = '/settings/edit-password';
  static const String security = '/settings/security';
  static const String languages = '/settings/languages';
  static const String currency = '/settings/currency';
  static const String printer = '/settings/printer';
  static const String subscription = '/settings/subscription';
  static const String backup = '/settings/backup';
  static const String treasury = '/treasury';
  static const String addPaymentFromClient = '/treasury/add-payment-from-client';
  static const String selectClient = '/treasury/select-client';
}
