import 'package:trucky/presentation/products/bloc/product_models.dart';

/// State exposed by [ProductBloc].
class ProductState {
  const ProductState({
    this.products = const <Product>[],
    this.productDetailsList = const <ProductDetail>[],
    this.selectedProduct,
    this.totalStockValue = 0,
    this.hideProductTotalBalance = false,
    this.hideDashboardTotalBalance = false,
    this.isLoaded = false,
  });

  final List<Product> products;
  final List<ProductDetail> productDetailsList;
  final Product? selectedProduct;
  final double totalStockValue;
  final bool hideProductTotalBalance;
  final bool hideDashboardTotalBalance;

  /// Whether products have been loaded at least once.
  final bool isLoaded;

  /// Sentinel distinguishing "not provided" from an explicit `null` (used to
  /// clear [selectedProduct]).
  static const Object _unset = Object();

  ProductState copyWith({
    List<Product>? products,
    List<ProductDetail>? productDetailsList,
    Object? selectedProduct = _unset,
    double? totalStockValue,
    bool? hideProductTotalBalance,
    bool? hideDashboardTotalBalance,
    bool? isLoaded,
  }) {
    return ProductState(
      products: products ?? this.products,
      productDetailsList: productDetailsList ?? this.productDetailsList,
      selectedProduct: identical(selectedProduct, _unset)
          ? this.selectedProduct
          : selectedProduct as Product?,
      totalStockValue: totalStockValue ?? this.totalStockValue,
      hideProductTotalBalance:
          hideProductTotalBalance ?? this.hideProductTotalBalance,
      hideDashboardTotalBalance:
          hideDashboardTotalBalance ?? this.hideDashboardTotalBalance,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}
