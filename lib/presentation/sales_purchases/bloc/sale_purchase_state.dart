import 'package:trucky/core/constants/enums.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_models.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_models.dart';

/// State exposed by [SalePurchaseBloc].
class SalePurchaseState {
  const SalePurchaseState({
    this.entityType = EntityType.client,
    this.transactionType = TransactionType.sale,
    this.operationType = OperationType.add,
    this.selectedClientSupp,
    this.selectedProdList = const [],
    this.selectedTileIndex = -1,
    this.editingItem,
    this.discountCash = 0,
    this.discountPercentage = 0,
    this.selectedTxn,
  });

  final EntityType entityType;
  final TransactionType transactionType;
  final OperationType operationType;
  final ClientSuppEntity? selectedClientSupp;
  final List<CartItem> selectedProdList;
  final int selectedTileIndex;
  final CartItem? editingItem;
  final double discountCash;
  final double discountPercentage;
  final ClientSuppTxn? selectedTxn;

  double get totalQuantity => selectedProdList
      .fold<int>(0, (sum, item) => sum + item.quantity)
      .toDouble();

  double get subtotal =>
      selectedProdList.fold<double>(0, (sum, item) => sum + item.lineTotal);

  double get discountAmount =>
      discountCash + subtotal * discountPercentage / 100;

  double get totalAfterDiscount => subtotal - discountAmount;

  bool isInCart(String productId) =>
      selectedProdList.any((item) => item.product.id == productId);

  SalePurchaseState copyWith({
    EntityType? entityType,
    TransactionType? transactionType,
    OperationType? operationType,
    ClientSuppEntity? selectedClientSupp,
    List<CartItem>? selectedProdList,
    int? selectedTileIndex,
    CartItem? editingItem,
    double? discountCash,
    double? discountPercentage,
    ClientSuppTxn? selectedTxn,
    bool clearSelectedClientSupp = false,
  }) {
    return SalePurchaseState(
      entityType: entityType ?? this.entityType,
      transactionType: transactionType ?? this.transactionType,
      operationType: operationType ?? this.operationType,
      selectedClientSupp: clearSelectedClientSupp
          ? null
          : (selectedClientSupp ?? this.selectedClientSupp),
      selectedProdList: selectedProdList ?? this.selectedProdList,
      selectedTileIndex: selectedTileIndex ?? this.selectedTileIndex,
      editingItem: editingItem ?? this.editingItem,
      discountCash: discountCash ?? this.discountCash,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      selectedTxn: selectedTxn ?? this.selectedTxn,
    );
  }
}
