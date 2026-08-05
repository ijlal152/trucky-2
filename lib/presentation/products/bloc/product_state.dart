import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trucky/presentation/products/bloc/product_models.dart';

part 'product_state.freezed.dart';

/// State exposed by [ProductBloc].
@freezed
abstract class ProductState with _$ProductState {
  const factory ProductState({
    @Default(<Product>[]) List<Product> products,
    @Default(<ProductDetail>[]) List<ProductDetail> productDetailsList,
    Product? selectedProduct,
    @Default(0) double totalStockValue,
    @Default(false) bool hideProductTotalBalance,
    @Default(false) bool hideDashboardTotalBalance,
    /// Whether products have been loaded at least once.
    @Default(false) bool isLoaded,
  }) = _ProductState;
}
