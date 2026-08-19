import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trucky/core/constants/enums.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_event.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_models.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_state.dart';

/// Holds the sale/purchase cart and flow state.
///
/// The lists (clients/suppliers/products) live in [ClientSuppBloc] and
/// [ProductBloc]; this bloc only tracks the in-flight transaction. Persisting
/// a completed transaction is orchestrated by the screens, which dispatch the
/// appropriate write events to those blocs.
class SalePurchaseBloc extends Bloc<SalePurchaseEvent, SalePurchaseState> {
  SalePurchaseBloc() : super(const SalePurchaseState()) {
    on<InitSalePurchaseEvent>(_onInit);
    on<ChooseClientSuppEvent>(_onChooseClientSupp);
    on<ToggleProductEvent>(_onToggleProduct);
    on<SetEditingItemEvent>(_onSetEditingItem);
    on<SetCartItemDataEvent>(_onSetCartItemData);
    on<ToggleCartExpansionEvent>(_onToggleExpansion);
    on<RemoveCartItemEvent>(_onRemoveCartItem);
    on<SetDiscountEvent>(_onSetDiscount);
    on<ClearDiscountEvent>(_onClearDiscount);
    on<ResetSalePurchaseDataEvent>(_onReset);
    on<BeginEditCartEvent>(_onBeginEditCart);
    on<BeginEditPaymentEvent>(_onBeginEditPayment);
  }

  void _onInit(InitSalePurchaseEvent event, Emitter<SalePurchaseState> emit) {
    emit(
      state.copyWith(
        entityType: event.entityType,
        transactionType: event.transactionType,
        operationType: OperationType.add,
        selectedProdList: const [],
        selectedTileIndex: -1,
        clearSelectedClientSupp: true,
        selectedTxn: null,
        discountCash: 0,
        discountPercentage: 0,
        returnToDashboard: false,
      ),
    );
  }

  void _onChooseClientSupp(
    ChooseClientSuppEvent event,
    Emitter<SalePurchaseState> emit,
  ) {
    emit(
      state.copyWith(
        selectedClientSupp: event.entity,
        selectedTileIndex: -1,
      ),
    );
  }

  void _onToggleProduct(ToggleProductEvent event, Emitter<SalePurchaseState> emit) {
    final product = event.product;
    if (product.availableStock <= 0) return;

    final items = [...state.selectedProdList];
    final existingIndex = items.indexWhere((i) => i.product.id == product.id);
    if (existingIndex >= 0) {
      items.removeAt(existingIndex);
    } else {
      items.add(CartItem.fromProduct(product, state.entityType));
    }

    emit(state.copyWith(selectedProdList: items));
  }

  void _onSetEditingItem(
    SetEditingItemEvent event,
    Emitter<SalePurchaseState> emit,
  ) {
    emit(state.copyWith(editingItem: event.item));
  }

  void _onSetCartItemData(
    SetCartItemDataEvent event,
    Emitter<SalePurchaseState> emit,
  ) {
    final items = state.selectedProdList.map((item) {
      if (item.product.id != event.productId) return item;
      return item.copyWith(
        quantity: event.quantity,
        unitPrice: event.unitPrice,
        quantityPerPackage: event.quantityPerPackage,
      );
    }).toList();

    emit(
      state.copyWith(
        selectedProdList: items,
        editingItem: null,
        selectedTileIndex: -1,
      ),
    );
  }

  void _onToggleExpansion(
    ToggleCartExpansionEvent event,
    Emitter<SalePurchaseState> emit,
  ) {
    emit(
      state.copyWith(
        selectedTileIndex: event.expanded ? event.index : -1,
      ),
    );
  }

  void _onRemoveCartItem(
    RemoveCartItemEvent event,
    Emitter<SalePurchaseState> emit,
  ) {
    final items = state.selectedProdList
        .where((item) => item.product.id != event.productId)
        .toList();
    emit(
      state.copyWith(
        selectedProdList: items,
        selectedTileIndex: -1,
      ),
    );
  }

  void _onSetDiscount(SetDiscountEvent event, Emitter<SalePurchaseState> emit) {
    emit(
      state.copyWith(
        discountCash: event.cash,
        discountPercentage: event.percentage,
      ),
    );
  }

  void _onClearDiscount(
    ClearDiscountEvent event,
    Emitter<SalePurchaseState> emit,
  ) {
    emit(state.copyWith(discountCash: 0, discountPercentage: 0));
  }

  void _onReset(
    ResetSalePurchaseDataEvent event,
    Emitter<SalePurchaseState> emit,
  ) {
    emit(
      state.copyWith(
        operationType: OperationType.add,
        selectedProdList: const [],
        selectedTileIndex: -1,
        clearSelectedClientSupp: true,
        editingItem: null,
        discountCash: 0,
        discountPercentage: 0,
        selectedTxn: null,
        returnToDashboard: false,
      ),
    );
  }

  void _onBeginEditCart(BeginEditCartEvent event, Emitter<SalePurchaseState> emit) {
    emit(
      state.copyWith(
        operationType: OperationType.edit,
        selectedTxn: event.txn,
        selectedClientSupp: event.clientSupp,
        selectedProdList: event.items,
        transactionType: event.txn.paymentType == 'Return'
            ? TransactionType.returnTransaction
            : TransactionType.sale,
        discountCash: double.tryParse(event.txn.discountAmount) ?? 0,
        discountPercentage: 0,
        selectedTileIndex: -1,
        editingItem: null,
        returnToDashboard: event.returnToDashboard,
      ),
    );
  }

  void _onBeginEditPayment(
    BeginEditPaymentEvent event,
    Emitter<SalePurchaseState> emit,
  ) {
    emit(
      state.copyWith(
        operationType: OperationType.edit,
        selectedTxn: event.txn,
        selectedClientSupp: event.clientSupp,
        selectedProdList: const [],
        selectedTileIndex: -1,
        editingItem: null,
        discountCash: 0,
        discountPercentage: 0,
        returnToDashboard: event.returnToDashboard,
      ),
    );
  }
}
