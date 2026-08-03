/// Central registry for route paths.
///
/// Keeping paths in one place avoids stringly-typed navigation and makes
/// the router easy to reason about.
abstract final class RoutePaths {
  static const String login = '/login';
  static const String home = '/home';
  static const String products = '/products';
  static const String addProduct = '/products/add';
  static const String productDashboard = '/products/dashboard';
}
