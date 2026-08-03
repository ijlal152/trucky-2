/// Events accepted by [ProductBloc].
sealed class ProductEvent {
  const ProductEvent();
}

class AddProductEvent extends ProductEvent {
  const AddProductEvent();
}

class RemoveProductEvent extends ProductEvent {
  const RemoveProductEvent({required this.id});

  final String id;
}
