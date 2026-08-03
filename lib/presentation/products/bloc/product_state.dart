import 'package:trucky/presentation/products/bloc/product_bloc.dart';

/// State exposed by [ProductBloc].
class ProductState {
  const ProductState({
    this.products = const [],
    this.productDetailsList = const [],
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

  /// Whether the sample products have been loaded at least once.
  final bool isLoaded;

  ProductState copyWith({
    List<Product>? products,
    List<ProductDetail>? productDetailsList,
    Product? selectedProduct,
    double? totalStockValue,
    bool? hideProductTotalBalance,
    bool? hideDashboardTotalBalance,
    bool? isLoaded,
    bool clearSelectedProduct = false,
  }) {
    return ProductState(
      products: products ?? this.products,
      productDetailsList: productDetailsList ?? this.productDetailsList,
      selectedProduct:
          clearSelectedProduct ? null : (selectedProduct ?? this.selectedProduct),
      totalStockValue: totalStockValue ?? this.totalStockValue,
      hideProductTotalBalance:
          hideProductTotalBalance ?? this.hideProductTotalBalance,
      hideDashboardTotalBalance:
          hideDashboardTotalBalance ?? this.hideDashboardTotalBalance,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}
