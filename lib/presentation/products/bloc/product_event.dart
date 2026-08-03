/// Events accepted by [ProductBloc].
sealed class ProductEvent {
  const ProductEvent();
}

class LoadProductsEvent extends ProductEvent {
  const LoadProductsEvent();
}

class AddProductEvent extends ProductEvent {
  const AddProductEvent({
    this.productName = '',
    this.productSKU,
    this.purchasePrice = 99.9,
    this.sellingPrice = 99.9,
    this.initialQuantity = 0,
    this.quantityPerPackage,
    this.productImage,
  });

  final String productName;
  final String? productSKU;
  final double purchasePrice;
  final double sellingPrice;
  final int initialQuantity;
  final String? quantityPerPackage;
  final String? productImage;
}

class RemoveProductEvent extends ProductEvent {
  const RemoveProductEvent({required this.id});

  final int id;
}

class ToggleProductBalanceVisibilityEvent extends ProductEvent {
  const ToggleProductBalanceVisibilityEvent();
}

class ToggleDashboardBalanceVisibilityEvent extends ProductEvent {
  const ToggleDashboardBalanceVisibilityEvent();
}

class SelectProductEvent extends ProductEvent {
  const SelectProductEvent({required this.id});

  final int id;
}
