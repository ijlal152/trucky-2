import 'package:flutter_riverpod/flutter_riverpod.dart';

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
final productsProvider = NotifierProvider<ProductsNotifier, List<Product>>(
  ProductsNotifier.new,
);

class ProductsNotifier extends Notifier<List<Product>> {
  static const List<String> _sampleNames = [
    'Engine Oil',
    'Brake Pads',
    'Air Filter',
    'Tires',
    'Battery',
  ];

  @override
  List<Product> build() => const [];

  void add() {
    final name = _sampleNames[state.length % _sampleNames.length];
    final product = Product(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      price: 99.9,
    );
    state = [...state, product];
  }

  void remove(String id) {
    state = state.where((p) => p.id != id).toList();
  }
}
