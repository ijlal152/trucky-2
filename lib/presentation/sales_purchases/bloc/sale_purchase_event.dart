import 'package:trucky/core/constants/enums.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_models.dart';
import 'package:trucky/presentation/products/bloc/product_models.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_models.dart';

/// Events accepted by [SalePurchaseBloc].
sealed class SalePurchaseEvent {
  const SalePurchaseEvent();
}

/// Initialises the flow for the given entity type and transaction kind.
class InitSalePurchaseEvent extends SalePurchaseEvent {
  const InitSalePurchaseEvent({
    this.entityType = EntityType.client,
    this.transactionType = TransactionType.sale,
  });

  final EntityType entityType;
  final TransactionType transactionType;
}

/// Picks the client/supplier the transaction is recorded against.
class ChooseClientSuppEvent extends SalePurchaseEvent {
  const ChooseClientSuppEvent({required this.entity});
  final ClientSupp entity;
}

/// Toggles a product in the cart (out-of-stock products are ignored).
class ToggleProductEvent extends SalePurchaseEvent {
  const ToggleProductEvent({required this.product});
  final Product product;
}

/// Marks the given cart item as being edited (opens the qty screen).
class SetEditingItemEvent extends SalePurchaseEvent {
  const SetEditingItemEvent(this.item);
  final CartItem? item;
}

/// Applies the qty screen values to an existing cart item.
class SetCartItemDataEvent extends SalePurchaseEvent {
  const SetCartItemDataEvent({
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    this.quantityPerPackage,
  });

  final int productId;
  final int quantity;
  final double unitPrice;
  final String? quantityPerPackage;
}

/// Expands/collapses a cart tile.
class ToggleCartExpansionEvent extends SalePurchaseEvent {
  const ToggleCartExpansionEvent({required this.index, required this.expanded});
  final int index;
  final bool expanded;
}

/// Removes an item from the cart.
class RemoveCartItemEvent extends SalePurchaseEvent {
  const RemoveCartItemEvent({required this.productId});
  final int productId;
}

/// Sets the cash + percentage discount.
class SetDiscountEvent extends SalePurchaseEvent {
  const SetDiscountEvent({required this.cash, required this.percentage});
  final double cash;
  final double percentage;
}

/// Clears the applied discount.
class ClearDiscountEvent extends SalePurchaseEvent {
  const ClearDiscountEvent();
}

/// Resets the whole flow state (new transaction).
class ResetSalePurchaseDataEvent extends SalePurchaseEvent {
  const ResetSalePurchaseDataEvent();
}

/// Begins editing an existing Sale/Purchase/Return transaction.
class BeginEditCartEvent extends SalePurchaseEvent {
  const BeginEditCartEvent({
    required this.txn,
    required this.clientSupp,
    required this.items,
    this.returnToDashboard = false,
  });

  final ClientSuppTxn txn;
  final ClientSupp clientSupp;
  final List<CartItem> items;

  /// Whether the edit started from the client/supplier dashboard, in which
  /// case the user should return there after the edit completes.
  final bool returnToDashboard;
}

/// Begins editing an existing Payment/Refund transaction.
class BeginEditPaymentEvent extends SalePurchaseEvent {
  const BeginEditPaymentEvent({
    required this.txn,
    required this.clientSupp,
    this.returnToDashboard = false,
  });

  final ClientSuppTxn txn;
  final ClientSupp clientSupp;

  /// Whether the edit started from the client/supplier dashboard, in which
  /// case the user should return there after the edit completes.
  final bool returnToDashboard;
}
