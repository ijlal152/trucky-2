import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trucky/presentation/products/bloc/product_event.dart';
import 'package:trucky/presentation/products/bloc/product_state.dart';
import 'package:trucky/presentation/widgets/custom_snackbar.dart';

/// Product model used by the products screens.
class Product {
  const Product({
    this.id,
    required this.productName,
    required this.purchasePrice,
    required this.sellingPrice,
    this.availableStock = 0,
    this.quantityPerPackage,
    this.productImage,
    this.productSKU,
    this.weightedAverageCost,
    this.createdAt,
  });

  final int? id;
  final String productName;
  final double purchasePrice;
  final double sellingPrice;
  final int availableStock;
  final String? quantityPerPackage;
  final String? productImage;
  final String? productSKU;
  final double? weightedAverageCost;
  final DateTime? createdAt;

  double get profit => sellingPrice - purchasePrice;

  bool get isInStock => availableStock > 0;

  double get totalValue => availableStock * sellingPrice;

  double get purchaseValue => availableStock * sellingPrice;

  double get effectiveCost => weightedAverageCost ?? purchasePrice;

  Product copyWith({
    int? id,
    String? productName,
    double? purchasePrice,
    double? sellingPrice,
    int? availableStock,
    String? quantityPerPackage,
    String? productImage,
    String? productSKU,
    double? weightedAverageCost,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      availableStock: availableStock ?? this.availableStock,
      quantityPerPackage: quantityPerPackage ?? this.quantityPerPackage,
      productImage: productImage ?? this.productImage,
      productSKU: productSKU ?? this.productSKU,
      weightedAverageCost: weightedAverageCost ?? this.weightedAverageCost,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// A single product transaction used on the product dashboard.
class ProductDetail {
  const ProductDetail({
    required this.productId,
    this.sourceName,
    this.sourceType,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.quantity,
    required this.paymentType,
    required this.createdAt,
    this.transactionId,
    this.quantityPerPackage,
  });

  final int productId;
  final String? sourceName;
  final String? sourceType;
  final double purchasePrice;
  final double sellingPrice;
  final int quantity;
  final String paymentType;
  final DateTime createdAt;

  /// Shared id linking this detail to its parent transaction, if any.
  final String? transactionId;

  final String? quantityPerPackage;
}

/// Holds product state and exposes mutations for the UI.
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(const ProductState()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<AddProductEvent>(_onAdd);
    on<RemoveProductEvent>(_onRemove);
    on<ToggleProductBalanceVisibilityEvent>(_onToggleProductBalance);
    on<ToggleDashboardBalanceVisibilityEvent>(_onToggleDashboardBalance);
    on<SelectProductEvent>(_onSelectProduct);
    on<AddProductDetailsEvent>(_onAddProductDetails);
    on<RemoveProductDetailsEvent>(_onRemoveProductDetails);
  }

  int _nextId = 1;

  static const List<String> _sampleNames = [
    'Engine Oil',
    'Brake Pads',
    'Air Filter',
    'Tires',
    'Battery',
  ];

  void _onLoadProducts(LoadProductsEvent event, Emitter<ProductState> emit) {
    final products = List<Product>.generate(
      _sampleNames.length,
      (index) => Product(
        id: _nextId++,
        productName: _sampleNames[index],
        purchasePrice: 80.0 + (index * 10),
        sellingPrice: 99.9 + (index * 12),
        availableStock: 10 + (index * 5),
        quantityPerPackage: '6',
        weightedAverageCost: 80.0 + (index * 10),
        createdAt: DateTime.now().subtract(Duration(days: index)),
      ),
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

  void _onAdd(AddProductEvent event, Emitter<ProductState> emit) {
    final productName = event.productName.trim();
    if (productName.isEmpty) {
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

    final now = DateTime.now();
    final product = Product(
      id: _nextId++,
      productName: productName,
      purchasePrice: event.purchasePrice,
      sellingPrice: event.sellingPrice,
      availableStock: event.initialQuantity,
      quantityPerPackage: event.quantityPerPackage,
      productImage: event.productImage,
      productSKU: event.productSKU,
      weightedAverageCost: event.purchasePrice,
      createdAt: now,
    );
    final products = [...state.products, product];
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
  }

  void _onRemove(RemoveProductEvent event, Emitter<ProductState> emit) {
    final products = state.products.where((p) => p.id != event.id).toList();
    final removedSelected = state.selectedProduct?.id == event.id;
    emit(
      state.copyWith(
        products: products,
        totalStockValue: products.fold<double>(
          0,
          (sum, p) => sum + p.totalValue,
        ),
        selectedProduct: removedSelected ? null : state.selectedProduct,
        productDetailsList:
            removedSelected ? const [] : state.productDetailsList,
        clearSelectedProduct: removedSelected,
      ),
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

  void _onSelectProduct(SelectProductEvent event, Emitter<ProductState> emit) {
    final product = state.products.where((p) => p.id == event.id).firstOrNull;
    if (product == null) return;

    final details = <ProductDetail>[
      ProductDetail(
        productId: product.id!,
        sourceName: 'Initial Stock',
        sourceType: 'supplier',
        purchasePrice: product.purchasePrice,
        sellingPrice: product.sellingPrice,
        quantity: product.availableStock,
        paymentType: 'Initial Stock',
        createdAt: product.createdAt ?? DateTime.now(),
      ),
    ];

    emit(
      state.copyWith(selectedProduct: product, productDetailsList: details),
    );
  }

  void _onAddProductDetails(
    AddProductDetailsEvent event,
    Emitter<ProductState> emit,
  ) {
    final products = state.products.map((product) {
      final matching = event.details.where((d) => d.productId == product.id);
      if (matching.isEmpty) return product;
      final totalDelta = matching.fold<int>(0, (sum, d) {
        switch (d.paymentType) {
          case 'Sale':
            return sum - d.quantity;
          case 'Purchase':
          case 'Return':
          case 'Initial Stock':
            return sum + d.quantity;
          default:
            return sum;
        }
      });
      return product.copyWith(
        availableStock: product.availableStock + totalDelta,
      );
    }).toList();

    emit(
      state.copyWith(
        products: products,
        productDetailsList: [...state.productDetailsList, ...event.details],
        totalStockValue: products.fold<double>(
          0,
          (sum, p) => sum + p.totalValue,
        ),
      ),
    );
  }

  void _onRemoveProductDetails(
    RemoveProductDetailsEvent event,
    Emitter<ProductState> emit,
  ) {
    final removed = state.productDetailsList
        .where((d) => d.transactionId == event.transactionId)
        .toList();
    if (removed.isEmpty) return;

    final products = state.products.map((product) {
      final matching = removed.where((d) => d.productId == product.id);
      if (matching.isEmpty) return product;
      final totalDelta = matching.fold<int>(0, (sum, d) {
        switch (d.paymentType) {
          case 'Sale':
            return sum + d.quantity; // restore sold stock
          case 'Purchase':
          case 'Return':
          case 'Initial Stock':
            return sum - d.quantity;
          default:
            return sum;
        }
      });
      return product.copyWith(
        availableStock: product.availableStock + totalDelta,
      );
    }).toList();

    emit(
      state.copyWith(
        products: products,
        productDetailsList: state.productDetailsList
            .where((d) => d.transactionId != event.transactionId)
            .toList(),
        totalStockValue: products.fold<double>(
          0,
          (sum, p) => sum + p.totalValue,
        ),
      ),
    );
  }
}
