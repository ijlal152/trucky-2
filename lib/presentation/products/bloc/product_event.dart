import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trucky/presentation/products/bloc/product_models.dart';

part 'product_event.freezed.dart';

/// Events accepted by [ProductBloc].
@freezed
abstract class ProductEvent with _$ProductEvent {
  const factory ProductEvent.loadProducts() = LoadProductsEvent;

  const factory ProductEvent.addProduct({
    @Default('') String productName,
    String? productSKU,
    @Default(99.9) double purchasePrice,
    @Default(99.9) double sellingPrice,
    @Default(0) int initialQuantity,
    String? quantityPerPackage,
    String? productImage,
  }) = AddProductEvent;

  const factory ProductEvent.removeProduct({required String id}) =
      RemoveProductEvent;

  const factory ProductEvent.toggleProductBalanceVisibility() =
      ToggleProductBalanceVisibilityEvent;

  const factory ProductEvent.toggleDashboardBalanceVisibility() =
      ToggleDashboardBalanceVisibilityEvent;

  const factory ProductEvent.selectProduct({required String id}) =
      SelectProductEvent;

  /// Appends product detail rows (from a sale/purchase/return) and adjusts the
  /// affected products' available stock.
  const factory ProductEvent.addProductDetails({
    required List<ProductDetail> details,
  }) = AddProductDetailsEvent;

  /// Removes product detail rows sharing a transaction id.
  ///
  /// Note: this event does NOT delete the underlying ledger row. Transactions
  /// are append-only by design. It only filters the row out of the current UI
  /// view.
  const factory ProductEvent.removeProductDetails({
    required String transactionId,
  }) = RemoveProductDetailsEvent;
}
