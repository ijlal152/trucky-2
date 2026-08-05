// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductState {

 List<Product> get products; List<ProductDetail> get productDetailsList; Product? get selectedProduct; double get totalStockValue; bool get hideProductTotalBalance; bool get hideDashboardTotalBalance;/// Whether products have been loaded at least once.
 bool get isLoaded;
/// Create a copy of ProductState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductStateCopyWith<ProductState> get copyWith => _$ProductStateCopyWithImpl<ProductState>(this as ProductState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductState&&const DeepCollectionEquality().equals(other.products, products)&&const DeepCollectionEquality().equals(other.productDetailsList, productDetailsList)&&(identical(other.selectedProduct, selectedProduct) || other.selectedProduct == selectedProduct)&&(identical(other.totalStockValue, totalStockValue) || other.totalStockValue == totalStockValue)&&(identical(other.hideProductTotalBalance, hideProductTotalBalance) || other.hideProductTotalBalance == hideProductTotalBalance)&&(identical(other.hideDashboardTotalBalance, hideDashboardTotalBalance) || other.hideDashboardTotalBalance == hideDashboardTotalBalance)&&(identical(other.isLoaded, isLoaded) || other.isLoaded == isLoaded));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(products),const DeepCollectionEquality().hash(productDetailsList),selectedProduct,totalStockValue,hideProductTotalBalance,hideDashboardTotalBalance,isLoaded);

@override
String toString() {
  return 'ProductState(products: $products, productDetailsList: $productDetailsList, selectedProduct: $selectedProduct, totalStockValue: $totalStockValue, hideProductTotalBalance: $hideProductTotalBalance, hideDashboardTotalBalance: $hideDashboardTotalBalance, isLoaded: $isLoaded)';
}


}

/// @nodoc
abstract mixin class $ProductStateCopyWith<$Res>  {
  factory $ProductStateCopyWith(ProductState value, $Res Function(ProductState) _then) = _$ProductStateCopyWithImpl;
@useResult
$Res call({
 List<Product> products, List<ProductDetail> productDetailsList, Product? selectedProduct, double totalStockValue, bool hideProductTotalBalance, bool hideDashboardTotalBalance, bool isLoaded
});


$ProductCopyWith<$Res>? get selectedProduct;

}
/// @nodoc
class _$ProductStateCopyWithImpl<$Res>
    implements $ProductStateCopyWith<$Res> {
  _$ProductStateCopyWithImpl(this._self, this._then);

  final ProductState _self;
  final $Res Function(ProductState) _then;

/// Create a copy of ProductState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? products = null,Object? productDetailsList = null,Object? selectedProduct = freezed,Object? totalStockValue = null,Object? hideProductTotalBalance = null,Object? hideDashboardTotalBalance = null,Object? isLoaded = null,}) {
  return _then(_self.copyWith(
products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,productDetailsList: null == productDetailsList ? _self.productDetailsList : productDetailsList // ignore: cast_nullable_to_non_nullable
as List<ProductDetail>,selectedProduct: freezed == selectedProduct ? _self.selectedProduct : selectedProduct // ignore: cast_nullable_to_non_nullable
as Product?,totalStockValue: null == totalStockValue ? _self.totalStockValue : totalStockValue // ignore: cast_nullable_to_non_nullable
as double,hideProductTotalBalance: null == hideProductTotalBalance ? _self.hideProductTotalBalance : hideProductTotalBalance // ignore: cast_nullable_to_non_nullable
as bool,hideDashboardTotalBalance: null == hideDashboardTotalBalance ? _self.hideDashboardTotalBalance : hideDashboardTotalBalance // ignore: cast_nullable_to_non_nullable
as bool,isLoaded: null == isLoaded ? _self.isLoaded : isLoaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of ProductState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductCopyWith<$Res>? get selectedProduct {
    if (_self.selectedProduct == null) {
    return null;
  }

  return $ProductCopyWith<$Res>(_self.selectedProduct!, (value) {
    return _then(_self.copyWith(selectedProduct: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductState].
extension ProductStatePatterns on ProductState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductState value)  $default,){
final _that = this;
switch (_that) {
case _ProductState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductState value)?  $default,){
final _that = this;
switch (_that) {
case _ProductState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Product> products,  List<ProductDetail> productDetailsList,  Product? selectedProduct,  double totalStockValue,  bool hideProductTotalBalance,  bool hideDashboardTotalBalance,  bool isLoaded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductState() when $default != null:
return $default(_that.products,_that.productDetailsList,_that.selectedProduct,_that.totalStockValue,_that.hideProductTotalBalance,_that.hideDashboardTotalBalance,_that.isLoaded);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Product> products,  List<ProductDetail> productDetailsList,  Product? selectedProduct,  double totalStockValue,  bool hideProductTotalBalance,  bool hideDashboardTotalBalance,  bool isLoaded)  $default,) {final _that = this;
switch (_that) {
case _ProductState():
return $default(_that.products,_that.productDetailsList,_that.selectedProduct,_that.totalStockValue,_that.hideProductTotalBalance,_that.hideDashboardTotalBalance,_that.isLoaded);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Product> products,  List<ProductDetail> productDetailsList,  Product? selectedProduct,  double totalStockValue,  bool hideProductTotalBalance,  bool hideDashboardTotalBalance,  bool isLoaded)?  $default,) {final _that = this;
switch (_that) {
case _ProductState() when $default != null:
return $default(_that.products,_that.productDetailsList,_that.selectedProduct,_that.totalStockValue,_that.hideProductTotalBalance,_that.hideDashboardTotalBalance,_that.isLoaded);case _:
  return null;

}
}

}

/// @nodoc


class _ProductState implements ProductState {
  const _ProductState({final  List<Product> products = const <Product>[], final  List<ProductDetail> productDetailsList = const <ProductDetail>[], this.selectedProduct, this.totalStockValue = 0, this.hideProductTotalBalance = false, this.hideDashboardTotalBalance = false, this.isLoaded = false}): _products = products,_productDetailsList = productDetailsList;
  

 final  List<Product> _products;
@override@JsonKey() List<Product> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

 final  List<ProductDetail> _productDetailsList;
@override@JsonKey() List<ProductDetail> get productDetailsList {
  if (_productDetailsList is EqualUnmodifiableListView) return _productDetailsList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_productDetailsList);
}

@override final  Product? selectedProduct;
@override@JsonKey() final  double totalStockValue;
@override@JsonKey() final  bool hideProductTotalBalance;
@override@JsonKey() final  bool hideDashboardTotalBalance;
/// Whether products have been loaded at least once.
@override@JsonKey() final  bool isLoaded;

/// Create a copy of ProductState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductStateCopyWith<_ProductState> get copyWith => __$ProductStateCopyWithImpl<_ProductState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductState&&const DeepCollectionEquality().equals(other._products, _products)&&const DeepCollectionEquality().equals(other._productDetailsList, _productDetailsList)&&(identical(other.selectedProduct, selectedProduct) || other.selectedProduct == selectedProduct)&&(identical(other.totalStockValue, totalStockValue) || other.totalStockValue == totalStockValue)&&(identical(other.hideProductTotalBalance, hideProductTotalBalance) || other.hideProductTotalBalance == hideProductTotalBalance)&&(identical(other.hideDashboardTotalBalance, hideDashboardTotalBalance) || other.hideDashboardTotalBalance == hideDashboardTotalBalance)&&(identical(other.isLoaded, isLoaded) || other.isLoaded == isLoaded));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_products),const DeepCollectionEquality().hash(_productDetailsList),selectedProduct,totalStockValue,hideProductTotalBalance,hideDashboardTotalBalance,isLoaded);

@override
String toString() {
  return 'ProductState(products: $products, productDetailsList: $productDetailsList, selectedProduct: $selectedProduct, totalStockValue: $totalStockValue, hideProductTotalBalance: $hideProductTotalBalance, hideDashboardTotalBalance: $hideDashboardTotalBalance, isLoaded: $isLoaded)';
}


}

/// @nodoc
abstract mixin class _$ProductStateCopyWith<$Res> implements $ProductStateCopyWith<$Res> {
  factory _$ProductStateCopyWith(_ProductState value, $Res Function(_ProductState) _then) = __$ProductStateCopyWithImpl;
@override @useResult
$Res call({
 List<Product> products, List<ProductDetail> productDetailsList, Product? selectedProduct, double totalStockValue, bool hideProductTotalBalance, bool hideDashboardTotalBalance, bool isLoaded
});


@override $ProductCopyWith<$Res>? get selectedProduct;

}
/// @nodoc
class __$ProductStateCopyWithImpl<$Res>
    implements _$ProductStateCopyWith<$Res> {
  __$ProductStateCopyWithImpl(this._self, this._then);

  final _ProductState _self;
  final $Res Function(_ProductState) _then;

/// Create a copy of ProductState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? products = null,Object? productDetailsList = null,Object? selectedProduct = freezed,Object? totalStockValue = null,Object? hideProductTotalBalance = null,Object? hideDashboardTotalBalance = null,Object? isLoaded = null,}) {
  return _then(_ProductState(
products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,productDetailsList: null == productDetailsList ? _self._productDetailsList : productDetailsList // ignore: cast_nullable_to_non_nullable
as List<ProductDetail>,selectedProduct: freezed == selectedProduct ? _self.selectedProduct : selectedProduct // ignore: cast_nullable_to_non_nullable
as Product?,totalStockValue: null == totalStockValue ? _self.totalStockValue : totalStockValue // ignore: cast_nullable_to_non_nullable
as double,hideProductTotalBalance: null == hideProductTotalBalance ? _self.hideProductTotalBalance : hideProductTotalBalance // ignore: cast_nullable_to_non_nullable
as bool,hideDashboardTotalBalance: null == hideDashboardTotalBalance ? _self.hideDashboardTotalBalance : hideDashboardTotalBalance // ignore: cast_nullable_to_non_nullable
as bool,isLoaded: null == isLoaded ? _self.isLoaded : isLoaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ProductState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductCopyWith<$Res>? get selectedProduct {
    if (_self.selectedProduct == null) {
    return null;
  }

  return $ProductCopyWith<$Res>(_self.selectedProduct!, (value) {
    return _then(_self.copyWith(selectedProduct: value));
  });
}
}

// dart format on
