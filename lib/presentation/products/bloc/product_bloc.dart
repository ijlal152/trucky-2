import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trucky/core/di/injector.dart';
import 'package:trucky/core/errors/failures.dart';
import 'package:trucky/core/utils/result.dart';
import 'package:trucky/domain/entities/product_entity.dart';
import 'package:trucky/domain/entities/product_transaction_type.dart';
import 'package:trucky/domain/repositories/product_repository.dart';
import 'package:trucky/presentation/products/bloc/product_event.dart';
import 'package:trucky/presentation/products/bloc/product_models.dart';
import 'package:trucky/presentation/products/bloc/product_state.dart';
import 'package:trucky/presentation/widgets/custom_snackbar.dart';

export 'product_models.dart';

/// Holds product state and exposes mutations for the UI.
///
/// This bloc is now **DB-backed**: every mutation goes through
/// [ProductRepository] which writes the ledger and the snapshot atomically.
/// In-memory sample data has been removed; the UI now reads from SQLite.
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({ProductRepository? repository})
    : _repository = repository ?? Injector.productRepository,
      super(const ProductState()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<AddProductEvent>(_onAdd);
    on<RemoveProductEvent>(_onRemove);
    on<ToggleProductBalanceVisibilityEvent>(_onToggleProductBalance);
    on<ToggleDashboardBalanceVisibilityEvent>(_onToggleDashboardBalance);
    on<SelectProductEvent>(_onSelectProduct);
    on<AddProductDetailsEvent>(_onAddProductDetails);
    on<RemoveProductDetailsEvent>(_onRemoveProductDetails);
  }

  final ProductRepository _repository;

  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    final result = await _repository.getAllProducts();
    final products = result.when(
      success: (rows) => rows.map(Product.fromEntity).toList(),
      failure: (failure) {
        MySnackbarMessage.showErrorMessage(
          title: 'Error!',
          message: failure.message,
        );
        return const <Product>[];
      },
    );
    emit(
      state.copyWith(
        products: products,
        isLoaded: true,
        totalStockValue: products.fold<double>(
          0,
          (sum, product) => sum + product.totalValue,
        ),
      ),
    );
  }

  Future<void> _onAdd(AddProductEvent event, Emitter<ProductState> emit) async {
    final productName = event.productName.trim();
    if (productName.isEmpty) {
      MySnackbarMessage.showErrorMessage(
        title: 'Error!',
        message: 'Product name is required.',
      );
      return;
    }

    final isDuplicate = state.products.any(
      (p) => p.productName.toLowerCase() == productName.toLowerCase(),
    );
    if (isDuplicate) {
      MySnackbarMessage.showErrorMessage(
        title: 'Error!',
        message: 'Product with the same name already exists.',
      );
      return;
    }

    final sku = (event.productSKU?.trim().isNotEmpty ?? false)
        ? event.productSKU!.trim()
        : 'SKU-${DateTime.now().millisecondsSinceEpoch}';

    final result = await _repository.createProduct(
      name: productName,
      sku: sku,
      sellingPrice: event.sellingPrice,
      initialQuantity: event.initialQuantity.toDouble(),
      initialPurchasePrice: event.purchasePrice,
    );

    await result.when(
      success: (entity) async {
        final products = [...state.products, Product.fromEntity(entity)];
        emit(
          state.copyWith(
            products: products,
            isLoaded: true,
            totalStockValue: products.fold<double>(
              0,
              (sum, p) => sum + p.totalValue,
            ),
          ),
        );
      },
      failure: (failure) {
        MySnackbarMessage.showErrorMessage(
          title: 'Error!',
          message: failure.message,
        );
      },
    );
  }

  Future<void> _onRemove(
    RemoveProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    final id = event.id;
    final result = await _repository.deleteProduct(id);
    await result.when(
      success: (_) async {
        final products = state.products.where((p) => p.id != id).toList();
        final removedSelected = state.selectedProduct?.id == id;
        emit(
          state.copyWith(
            products: products,
            totalStockValue: products.fold<double>(
              0,
              (sum, p) => sum + p.totalValue,
            ),
            selectedProduct: removedSelected ? null : state.selectedProduct,
            productDetailsList: removedSelected
                ? const []
                : state.productDetailsList,
            clearSelectedProduct: removedSelected,
          ),
        );
      },
      failure: (failure) {
        MySnackbarMessage.showErrorMessage(
          title: 'Error!',
          message: failure.message,
        );
      },
    );
  }

  void _onToggleProductBalance(
    ToggleProductBalanceVisibilityEvent event,
    Emitter<ProductState> emit,
  ) {
    emit(
      state.copyWith(hideProductTotalBalance: !state.hideProductTotalBalance),
    );
  }

  void _onToggleDashboardBalance(
    ToggleDashboardBalanceVisibilityEvent event,
    Emitter<ProductState> emit,
  ) {
    emit(
      state.copyWith(
        hideDashboardTotalBalance: !state.hideDashboardTotalBalance,
      ),
    );
  }

  Future<void> _onSelectProduct(
    SelectProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    final product = state.products.where((p) => p.id == event.id).firstOrNull;
    if (product == null) return;

    final result = await _repository.getTransactionsForProduct(event.id);
    final details = result.when(
      success: (rows) => rows.map(ProductDetail.fromEntity).toList(),
      failure: (_) => const <ProductDetail>[],
    );

    emit(state.copyWith(selectedProduct: product, productDetailsList: details));
  }

  Future<void> _onAddProductDetails(
    AddProductDetailsEvent event,
    Emitter<ProductState> emit,
  ) async {
    final details = event.details;
    if (details.isEmpty) return;

    final updatedProducts = List<Product>.from(state.products);
    final newLedgerRows = <ProductDetail>[];

    for (final detail in details) {
      final op = _opFromPaymentType(detail.paymentType);
      if (op == null) continue;

      late final Future<Result<ProductEntity>> futureResult;
      switch (op) {
        case ProductTransactionType.purchase:
          futureResult = _repository.recordPurchase(
            productId: detail.productId,
            quantity: detail.quantity.toDouble(),
            unitPrice: detail.purchasePrice,
          );
          break;
        case ProductTransactionType.sale:
          futureResult = _repository.recordSale(
            productId: detail.productId,
            quantity: detail.quantity.toDouble(),
            unitPrice: detail.sellingPrice,
          );
          break;
        case ProductTransactionType.returned:
          futureResult = _repository.recordReturn(
            productId: detail.productId,
            quantity: detail.quantity.toDouble(),
            unitPrice: detail.purchasePrice,
          );
          break;
      }
      final result = await futureResult;

      result.when(
        success: (entity) async {
          final idx = updatedProducts.indexWhere((p) => p.id == entity.id);
          if (idx >= 0) {
            updatedProducts[idx] = Product.fromEntity(entity);
          }
          final txns = await _repository.getTransactionsForProduct(entity.id);
          txns.when(
            success: (rows) {
              if (rows.isNotEmpty) {
                newLedgerRows.add(ProductDetail.fromEntity(rows.first));
              }
            },
            failure: (_) {},
          );
        },
        failure: (failure) {
          MySnackbarMessage.showErrorMessage(
            title: 'Error!',
            message: failure is InsufficientStockFailure
                ? 'Insufficient stock for ${detail.productId}.'
                : failure.message,
          );
        },
      );
    }

    emit(
      state.copyWith(
        products: updatedProducts,
        productDetailsList: [...state.productDetailsList, ...newLedgerRows],
        totalStockValue: updatedProducts.fold<double>(
          0,
          (sum, p) => sum + p.totalValue,
        ),
      ),
    );
  }

  Future<void> _onRemoveProductDetails(
    RemoveProductDetailsEvent event,
    Emitter<ProductState> emit,
  ) {
    // Transactions are append-only by design (audit + sync). Removing them
    // would violate the design contract. Instead, this event simply hides
    // the row from the current view; the ledger stays intact.
    final filtered = state.productDetailsList
        .where((d) => d.transactionId != event.transactionId)
        .toList();
    emit(state.copyWith(productDetailsList: filtered));
    return Future.value();
  }

  ProductTransactionType? _opFromPaymentType(String paymentType) {
    switch (paymentType) {
      case 'Sale':
        return ProductTransactionType.sale;
      case 'Purchase':
      case 'Initial Stock':
        return ProductTransactionType.purchase;
      case 'Return':
        return ProductTransactionType.returned;
      default:
        return null;
    }
  }
}
