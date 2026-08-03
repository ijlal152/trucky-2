import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trucky/presentation/products/bloc/product_event.dart';
import 'package:trucky/presentation/products/bloc/product_state.dart';

/// Simple product model used by the products screen.
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
  });

  final String id;
  final String name;
  final double price;
}

/// Holds the list of products and exposes mutations for the UI.
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(const ProductState()) {
    on<AddProductEvent>(_onAdd);
    on<RemoveProductEvent>(_onRemove);
  }

  static const List<String> _sampleNames = [
    'Engine Oil',
    'Brake Pads',
    'Air Filter',
    'Tires',
    'Battery',
  ];

  void _onAdd(AddProductEvent event, Emitter<ProductState> emit) {
    final name = _sampleNames[state.products.length % _sampleNames.length];
    final product = Product(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      price: 99.9,
    );
    emit(state.copyWith(products: [...state.products, product]));
  }

  void _onRemove(RemoveProductEvent event, Emitter<ProductState> emit) {
    emit(
      state.copyWith(
        products: state.products.where((p) => p.id != event.id).toList(),
      ),
    );
  }
}
