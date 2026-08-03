import 'package:trucky/presentation/products/bloc/product_bloc.dart';

/// State exposed by [ProductBloc].
class ProductState {
  const ProductState({this.products = const []});

  final List<Product> products;

  ProductState copyWith({List<Product>? products}) {
    return ProductState(products: products ?? this.products);
  }
}
