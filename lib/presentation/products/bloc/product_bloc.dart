import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trucky/core/di/injector.dart';
import 'package:trucky/core/errors/failures.dart';
import 'package:trucky/core/usecase/usecase.dart';
import 'package:trucky/domain/entities/product_entity.dart';
import 'package:trucky/domain/entities/product_transaction_type.dart';
import 'package:trucky/domain/usecases/create_product_usecase.dart';
import 'package:trucky/domain/usecases/delete_product_usecase.dart';
import 'package:trucky/domain/usecases/get_all_products_usecase.dart';
import 'package:trucky/domain/usecases/get_product_transactions_usecase.dart';
import 'package:trucky/domain/usecases/record_purchase_usecase.dart';
import 'package:trucky/domain/usecases/record_return_usecase.dart';
import 'package:trucky/domain/usecases/record_sale_usecase.dart';
import 'package:trucky/domain/usecases/record_transaction_params.dart';
import 'package:trucky/presentation/products/bloc/product_event.dart';
import 'package:trucky/presentation/products/bloc/product_models.dart';
import 'package:trucky/presentation/products/bloc/product_state.dart';
import 'package:trucky/presentation/widgets/custom_snackbar.dart';

export 'product_models.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({
    GetAllProductsUsecase? getAllProducts,
    CreateProductUsecase? createProduct,
    DeleteProductUsecase? deleteProduct,
    GetProductTransactionsUsecase? getProductTransactions,
    RecordPurchaseUsecase? recordPurchase,
    RecordSaleUsecase? recordSale,
    RecordReturnUsecase? recordReturn,
  }) : _getAllProducts = getAllProducts ?? Injector.getAllProductsUsecase,
       _createProduct = createProduct ?? Injector.createProductUsecase,
       _deleteProduct = deleteProduct ?? Injector.deleteProductUsecase,
       _getProductTransactions =
           getProductTransactions ?? Injector.getProductTransactionsUsecase,
       _recordPurchase = recordPurchase ?? Injector.recordPurchaseUsecase,
       _recordSale = recordSale ?? Injector.recordSaleUsecase,
       _recordReturn = recordReturn ?? Injector.recordReturnUsecase,
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

  final GetAllProductsUsecase _getAllProducts;
  final CreateProductUsecase _createProduct;
  final DeleteProductUsecase _deleteProduct;
  final GetProductTransactionsUsecase _getProductTransactions;
  final RecordPurchaseUsecase _recordPurchase;
  final RecordSaleUsecase _recordSale;
  final RecordReturnUsecase _recordReturn;

  /// Per-product transaction cache keyed by product id, so tapping a product
  /// on the list reuses the already-loaded ledger instead of hitting the
  /// database again.
  final Map<String, List<ProductDetail>> _txnCache = {};

  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    final result = await _getAllProducts(const NoParams());
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

    final withAvailableStock = await _withLedgerStock(products);
    emit(
      state.copyWith(
        products: withAvailableStock,
        isLoaded: true,
        totalStockValue: withAvailableStock.fold<double>(
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

    final result = await _createProduct(
      CreateProductParams(
        name: productName,
        sku: sku,
        sellingPrice: event.sellingPrice,
        initialQuantity: event.initialQuantity,
        initialPurchasePrice: event.purchasePrice,
      ),
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
    final result = await _deleteProduct(id);
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
                ? const <ProductDetail>[]
                : state.productDetailsList,
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

    final details = await _detailsFor(event.id);

    emit(
      state.copyWith(
        selectedProduct: product.copyWith(
          availableStock: _availableStockFrom(details),
        ),
        productDetailsList: details,
      ),
    );
  }

  /// Recomputes each product's available stock from its transaction ledger so
  /// the product list always shows the live stock rather than the cached
  /// snapshot.
  Future<List<Product>> _withLedgerStock(List<Product> products) async {
    final updated = <Product>[];
    for (final product in products) {
      final id = product.id;
      if (id == null) {
        updated.add(product);
        continue;
      }
      final details = await _detailsFor(id);
      updated.add(
        product.copyWith(availableStock: _availableStockFrom(details)),
      );
    }
    return updated;
  }

  /// Returns the product's transaction details, reusing the in-memory cache
  /// when available so tapping a product does not re-read the database.
  Future<List<ProductDetail>> _detailsFor(String productId) async {
    final cached = _txnCache[productId];
    if (cached != null) return cached;
    final result = await _getProductTransactions(productId);
    final details = result.when(
      success: (rows) => rows.map(ProductDetail.fromEntity).toList(),
      failure: (_) => const <ProductDetail>[],
    );
    _txnCache[productId] = details;
    return details;
  }

  int _availableStockFrom(List<ProductDetail> details) {
    return details.fold<int>(
      0,
      (sum, detail) =>
          sum + _stockSignFor(detail.paymentType) * detail.quantity,
    );
  }

  int _stockSignFor(String paymentType) {
    switch (paymentType) {
      case 'Sale':
        return -1;
      case 'Initial Stock':
      case 'Purchase':
      case 'Return':
        return 1;
      default:
        return 0;
    }
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

      final params = RecordTransactionParams(
        productId: detail.productId,
        quantity: detail.quantity,
        unitPrice: op == ProductTransactionType.sale
            ? detail.sellingPrice
            : detail.purchasePrice,
        sourceName: detail.sourceName,
        sourceType: detail.sourceType,
      );

      final result = switch (op) {
        ProductTransactionType.initialStock => await _recordPurchase(params),
        ProductTransactionType.purchase => await _recordPurchase(params),
        ProductTransactionType.sale => await _recordSale(params),
        ProductTransactionType.returned => await _recordReturn(params),
      };

      // Await the success path explicitly so the product snapshot and ledger
      // rows are updated BEFORE the single emit below. The previous
      // `result.when(success: (entity) async { ... })` never awaited the
      // callback, so the emitted state could be stale (lost stock updates).
      final entity = result.when<ProductEntity?>(
        success: (value) => value,
        failure: (failure) {
          MySnackbarMessage.showErrorMessage(
            title: 'Error!',
            message: failure is InsufficientStockFailure
                ? 'Insufficient stock for ${detail.productId}.'
                : failure.message,
          );
          return null;
        },
      );
      if (entity == null) continue;

      final idx = updatedProducts.indexWhere((p) => p.id == entity.id);
      if (idx >= 0) {
        updatedProducts[idx] = Product.fromEntity(entity);
      }

      // The ledger changed; drop the cached details so the next read reflects
      // the new transaction.
      _txnCache.remove(entity.id);

      final txns = await _getProductTransactions(entity.id);
      txns.when(
        success: (rows) {
          if (rows.isNotEmpty) {
            newLedgerRows.add(ProductDetail.fromEntity(rows.first));
          }
        },
        failure: (_) {},
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
