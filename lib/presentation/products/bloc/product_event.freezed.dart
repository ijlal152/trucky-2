// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductEvent()';
}


}

/// @nodoc
class $ProductEventCopyWith<$Res>  {
$ProductEventCopyWith(ProductEvent _, $Res Function(ProductEvent) __);
}


/// Adds pattern-matching-related methods to [ProductEvent].
extension ProductEventPatterns on ProductEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadProductsEvent value)?  loadProducts,TResult Function( AddProductEvent value)?  addProduct,TResult Function( RemoveProductEvent value)?  removeProduct,TResult Function( ToggleProductBalanceVisibilityEvent value)?  toggleProductBalanceVisibility,TResult Function( ToggleDashboardBalanceVisibilityEvent value)?  toggleDashboardBalanceVisibility,TResult Function( SelectProductEvent value)?  selectProduct,TResult Function( AddProductDetailsEvent value)?  addProductDetails,TResult Function( RemoveProductDetailsEvent value)?  removeProductDetails,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadProductsEvent() when loadProducts != null:
return loadProducts(_that);case AddProductEvent() when addProduct != null:
return addProduct(_that);case RemoveProductEvent() when removeProduct != null:
return removeProduct(_that);case ToggleProductBalanceVisibilityEvent() when toggleProductBalanceVisibility != null:
return toggleProductBalanceVisibility(_that);case ToggleDashboardBalanceVisibilityEvent() when toggleDashboardBalanceVisibility != null:
return toggleDashboardBalanceVisibility(_that);case SelectProductEvent() when selectProduct != null:
return selectProduct(_that);case AddProductDetailsEvent() when addProductDetails != null:
return addProductDetails(_that);case RemoveProductDetailsEvent() when removeProductDetails != null:
return removeProductDetails(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadProductsEvent value)  loadProducts,required TResult Function( AddProductEvent value)  addProduct,required TResult Function( RemoveProductEvent value)  removeProduct,required TResult Function( ToggleProductBalanceVisibilityEvent value)  toggleProductBalanceVisibility,required TResult Function( ToggleDashboardBalanceVisibilityEvent value)  toggleDashboardBalanceVisibility,required TResult Function( SelectProductEvent value)  selectProduct,required TResult Function( AddProductDetailsEvent value)  addProductDetails,required TResult Function( RemoveProductDetailsEvent value)  removeProductDetails,}){
final _that = this;
switch (_that) {
case LoadProductsEvent():
return loadProducts(_that);case AddProductEvent():
return addProduct(_that);case RemoveProductEvent():
return removeProduct(_that);case ToggleProductBalanceVisibilityEvent():
return toggleProductBalanceVisibility(_that);case ToggleDashboardBalanceVisibilityEvent():
return toggleDashboardBalanceVisibility(_that);case SelectProductEvent():
return selectProduct(_that);case AddProductDetailsEvent():
return addProductDetails(_that);case RemoveProductDetailsEvent():
return removeProductDetails(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadProductsEvent value)?  loadProducts,TResult? Function( AddProductEvent value)?  addProduct,TResult? Function( RemoveProductEvent value)?  removeProduct,TResult? Function( ToggleProductBalanceVisibilityEvent value)?  toggleProductBalanceVisibility,TResult? Function( ToggleDashboardBalanceVisibilityEvent value)?  toggleDashboardBalanceVisibility,TResult? Function( SelectProductEvent value)?  selectProduct,TResult? Function( AddProductDetailsEvent value)?  addProductDetails,TResult? Function( RemoveProductDetailsEvent value)?  removeProductDetails,}){
final _that = this;
switch (_that) {
case LoadProductsEvent() when loadProducts != null:
return loadProducts(_that);case AddProductEvent() when addProduct != null:
return addProduct(_that);case RemoveProductEvent() when removeProduct != null:
return removeProduct(_that);case ToggleProductBalanceVisibilityEvent() when toggleProductBalanceVisibility != null:
return toggleProductBalanceVisibility(_that);case ToggleDashboardBalanceVisibilityEvent() when toggleDashboardBalanceVisibility != null:
return toggleDashboardBalanceVisibility(_that);case SelectProductEvent() when selectProduct != null:
return selectProduct(_that);case AddProductDetailsEvent() when addProductDetails != null:
return addProductDetails(_that);case RemoveProductDetailsEvent() when removeProductDetails != null:
return removeProductDetails(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadProducts,TResult Function( String productName,  String? productSKU,  double purchasePrice,  double sellingPrice,  int initialQuantity,  String? quantityPerPackage,  String? productImage)?  addProduct,TResult Function( String id)?  removeProduct,TResult Function()?  toggleProductBalanceVisibility,TResult Function()?  toggleDashboardBalanceVisibility,TResult Function( String id)?  selectProduct,TResult Function( List<ProductDetail> details)?  addProductDetails,TResult Function( String transactionId)?  removeProductDetails,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadProductsEvent() when loadProducts != null:
return loadProducts();case AddProductEvent() when addProduct != null:
return addProduct(_that.productName,_that.productSKU,_that.purchasePrice,_that.sellingPrice,_that.initialQuantity,_that.quantityPerPackage,_that.productImage);case RemoveProductEvent() when removeProduct != null:
return removeProduct(_that.id);case ToggleProductBalanceVisibilityEvent() when toggleProductBalanceVisibility != null:
return toggleProductBalanceVisibility();case ToggleDashboardBalanceVisibilityEvent() when toggleDashboardBalanceVisibility != null:
return toggleDashboardBalanceVisibility();case SelectProductEvent() when selectProduct != null:
return selectProduct(_that.id);case AddProductDetailsEvent() when addProductDetails != null:
return addProductDetails(_that.details);case RemoveProductDetailsEvent() when removeProductDetails != null:
return removeProductDetails(_that.transactionId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadProducts,required TResult Function( String productName,  String? productSKU,  double purchasePrice,  double sellingPrice,  int initialQuantity,  String? quantityPerPackage,  String? productImage)  addProduct,required TResult Function( String id)  removeProduct,required TResult Function()  toggleProductBalanceVisibility,required TResult Function()  toggleDashboardBalanceVisibility,required TResult Function( String id)  selectProduct,required TResult Function( List<ProductDetail> details)  addProductDetails,required TResult Function( String transactionId)  removeProductDetails,}) {final _that = this;
switch (_that) {
case LoadProductsEvent():
return loadProducts();case AddProductEvent():
return addProduct(_that.productName,_that.productSKU,_that.purchasePrice,_that.sellingPrice,_that.initialQuantity,_that.quantityPerPackage,_that.productImage);case RemoveProductEvent():
return removeProduct(_that.id);case ToggleProductBalanceVisibilityEvent():
return toggleProductBalanceVisibility();case ToggleDashboardBalanceVisibilityEvent():
return toggleDashboardBalanceVisibility();case SelectProductEvent():
return selectProduct(_that.id);case AddProductDetailsEvent():
return addProductDetails(_that.details);case RemoveProductDetailsEvent():
return removeProductDetails(_that.transactionId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadProducts,TResult? Function( String productName,  String? productSKU,  double purchasePrice,  double sellingPrice,  int initialQuantity,  String? quantityPerPackage,  String? productImage)?  addProduct,TResult? Function( String id)?  removeProduct,TResult? Function()?  toggleProductBalanceVisibility,TResult? Function()?  toggleDashboardBalanceVisibility,TResult? Function( String id)?  selectProduct,TResult? Function( List<ProductDetail> details)?  addProductDetails,TResult? Function( String transactionId)?  removeProductDetails,}) {final _that = this;
switch (_that) {
case LoadProductsEvent() when loadProducts != null:
return loadProducts();case AddProductEvent() when addProduct != null:
return addProduct(_that.productName,_that.productSKU,_that.purchasePrice,_that.sellingPrice,_that.initialQuantity,_that.quantityPerPackage,_that.productImage);case RemoveProductEvent() when removeProduct != null:
return removeProduct(_that.id);case ToggleProductBalanceVisibilityEvent() when toggleProductBalanceVisibility != null:
return toggleProductBalanceVisibility();case ToggleDashboardBalanceVisibilityEvent() when toggleDashboardBalanceVisibility != null:
return toggleDashboardBalanceVisibility();case SelectProductEvent() when selectProduct != null:
return selectProduct(_that.id);case AddProductDetailsEvent() when addProductDetails != null:
return addProductDetails(_that.details);case RemoveProductDetailsEvent() when removeProductDetails != null:
return removeProductDetails(_that.transactionId);case _:
  return null;

}
}

}

/// @nodoc


class LoadProductsEvent implements ProductEvent {
  const LoadProductsEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadProductsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductEvent.loadProducts()';
}


}




/// @nodoc


class AddProductEvent implements ProductEvent {
  const AddProductEvent({this.productName = '', this.productSKU, this.purchasePrice = 99.9, this.sellingPrice = 99.9, this.initialQuantity = 0, this.quantityPerPackage, this.productImage});
  

@JsonKey() final  String productName;
 final  String? productSKU;
@JsonKey() final  double purchasePrice;
@JsonKey() final  double sellingPrice;
@JsonKey() final  int initialQuantity;
 final  String? quantityPerPackage;
 final  String? productImage;

/// Create a copy of ProductEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddProductEventCopyWith<AddProductEvent> get copyWith => _$AddProductEventCopyWithImpl<AddProductEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddProductEvent&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productSKU, productSKU) || other.productSKU == productSKU)&&(identical(other.purchasePrice, purchasePrice) || other.purchasePrice == purchasePrice)&&(identical(other.sellingPrice, sellingPrice) || other.sellingPrice == sellingPrice)&&(identical(other.initialQuantity, initialQuantity) || other.initialQuantity == initialQuantity)&&(identical(other.quantityPerPackage, quantityPerPackage) || other.quantityPerPackage == quantityPerPackage)&&(identical(other.productImage, productImage) || other.productImage == productImage));
}


@override
int get hashCode => Object.hash(runtimeType,productName,productSKU,purchasePrice,sellingPrice,initialQuantity,quantityPerPackage,productImage);

@override
String toString() {
  return 'ProductEvent.addProduct(productName: $productName, productSKU: $productSKU, purchasePrice: $purchasePrice, sellingPrice: $sellingPrice, initialQuantity: $initialQuantity, quantityPerPackage: $quantityPerPackage, productImage: $productImage)';
}


}

/// @nodoc
abstract mixin class $AddProductEventCopyWith<$Res> implements $ProductEventCopyWith<$Res> {
  factory $AddProductEventCopyWith(AddProductEvent value, $Res Function(AddProductEvent) _then) = _$AddProductEventCopyWithImpl;
@useResult
$Res call({
 String productName, String? productSKU, double purchasePrice, double sellingPrice, int initialQuantity, String? quantityPerPackage, String? productImage
});




}
/// @nodoc
class _$AddProductEventCopyWithImpl<$Res>
    implements $AddProductEventCopyWith<$Res> {
  _$AddProductEventCopyWithImpl(this._self, this._then);

  final AddProductEvent _self;
  final $Res Function(AddProductEvent) _then;

/// Create a copy of ProductEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? productName = null,Object? productSKU = freezed,Object? purchasePrice = null,Object? sellingPrice = null,Object? initialQuantity = null,Object? quantityPerPackage = freezed,Object? productImage = freezed,}) {
  return _then(AddProductEvent(
productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,productSKU: freezed == productSKU ? _self.productSKU : productSKU // ignore: cast_nullable_to_non_nullable
as String?,purchasePrice: null == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as double,sellingPrice: null == sellingPrice ? _self.sellingPrice : sellingPrice // ignore: cast_nullable_to_non_nullable
as double,initialQuantity: null == initialQuantity ? _self.initialQuantity : initialQuantity // ignore: cast_nullable_to_non_nullable
as int,quantityPerPackage: freezed == quantityPerPackage ? _self.quantityPerPackage : quantityPerPackage // ignore: cast_nullable_to_non_nullable
as String?,productImage: freezed == productImage ? _self.productImage : productImage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class RemoveProductEvent implements ProductEvent {
  const RemoveProductEvent({required this.id});
  

 final  String id;

/// Create a copy of ProductEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoveProductEventCopyWith<RemoveProductEvent> get copyWith => _$RemoveProductEventCopyWithImpl<RemoveProductEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoveProductEvent&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'ProductEvent.removeProduct(id: $id)';
}


}

/// @nodoc
abstract mixin class $RemoveProductEventCopyWith<$Res> implements $ProductEventCopyWith<$Res> {
  factory $RemoveProductEventCopyWith(RemoveProductEvent value, $Res Function(RemoveProductEvent) _then) = _$RemoveProductEventCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$RemoveProductEventCopyWithImpl<$Res>
    implements $RemoveProductEventCopyWith<$Res> {
  _$RemoveProductEventCopyWithImpl(this._self, this._then);

  final RemoveProductEvent _self;
  final $Res Function(RemoveProductEvent) _then;

/// Create a copy of ProductEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(RemoveProductEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ToggleProductBalanceVisibilityEvent implements ProductEvent {
  const ToggleProductBalanceVisibilityEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToggleProductBalanceVisibilityEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductEvent.toggleProductBalanceVisibility()';
}


}




/// @nodoc


class ToggleDashboardBalanceVisibilityEvent implements ProductEvent {
  const ToggleDashboardBalanceVisibilityEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToggleDashboardBalanceVisibilityEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductEvent.toggleDashboardBalanceVisibility()';
}


}




/// @nodoc


class SelectProductEvent implements ProductEvent {
  const SelectProductEvent({required this.id});
  

 final  String id;

/// Create a copy of ProductEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectProductEventCopyWith<SelectProductEvent> get copyWith => _$SelectProductEventCopyWithImpl<SelectProductEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectProductEvent&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'ProductEvent.selectProduct(id: $id)';
}


}

/// @nodoc
abstract mixin class $SelectProductEventCopyWith<$Res> implements $ProductEventCopyWith<$Res> {
  factory $SelectProductEventCopyWith(SelectProductEvent value, $Res Function(SelectProductEvent) _then) = _$SelectProductEventCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$SelectProductEventCopyWithImpl<$Res>
    implements $SelectProductEventCopyWith<$Res> {
  _$SelectProductEventCopyWithImpl(this._self, this._then);

  final SelectProductEvent _self;
  final $Res Function(SelectProductEvent) _then;

/// Create a copy of ProductEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(SelectProductEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AddProductDetailsEvent implements ProductEvent {
  const AddProductDetailsEvent({required final  List<ProductDetail> details}): _details = details;
  

 final  List<ProductDetail> _details;
 List<ProductDetail> get details {
  if (_details is EqualUnmodifiableListView) return _details;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_details);
}


/// Create a copy of ProductEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddProductDetailsEventCopyWith<AddProductDetailsEvent> get copyWith => _$AddProductDetailsEventCopyWithImpl<AddProductDetailsEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddProductDetailsEvent&&const DeepCollectionEquality().equals(other._details, _details));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_details));

@override
String toString() {
  return 'ProductEvent.addProductDetails(details: $details)';
}


}

/// @nodoc
abstract mixin class $AddProductDetailsEventCopyWith<$Res> implements $ProductEventCopyWith<$Res> {
  factory $AddProductDetailsEventCopyWith(AddProductDetailsEvent value, $Res Function(AddProductDetailsEvent) _then) = _$AddProductDetailsEventCopyWithImpl;
@useResult
$Res call({
 List<ProductDetail> details
});




}
/// @nodoc
class _$AddProductDetailsEventCopyWithImpl<$Res>
    implements $AddProductDetailsEventCopyWith<$Res> {
  _$AddProductDetailsEventCopyWithImpl(this._self, this._then);

  final AddProductDetailsEvent _self;
  final $Res Function(AddProductDetailsEvent) _then;

/// Create a copy of ProductEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? details = null,}) {
  return _then(AddProductDetailsEvent(
details: null == details ? _self._details : details // ignore: cast_nullable_to_non_nullable
as List<ProductDetail>,
  ));
}


}

/// @nodoc


class RemoveProductDetailsEvent implements ProductEvent {
  const RemoveProductDetailsEvent({required this.transactionId});
  

 final  String transactionId;

/// Create a copy of ProductEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoveProductDetailsEventCopyWith<RemoveProductDetailsEvent> get copyWith => _$RemoveProductDetailsEventCopyWithImpl<RemoveProductDetailsEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoveProductDetailsEvent&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId));
}


@override
int get hashCode => Object.hash(runtimeType,transactionId);

@override
String toString() {
  return 'ProductEvent.removeProductDetails(transactionId: $transactionId)';
}


}

/// @nodoc
abstract mixin class $RemoveProductDetailsEventCopyWith<$Res> implements $ProductEventCopyWith<$Res> {
  factory $RemoveProductDetailsEventCopyWith(RemoveProductDetailsEvent value, $Res Function(RemoveProductDetailsEvent) _then) = _$RemoveProductDetailsEventCopyWithImpl;
@useResult
$Res call({
 String transactionId
});




}
/// @nodoc
class _$RemoveProductDetailsEventCopyWithImpl<$Res>
    implements $RemoveProductDetailsEventCopyWith<$Res> {
  _$RemoveProductDetailsEventCopyWithImpl(this._self, this._then);

  final RemoveProductDetailsEvent _self;
  final $Res Function(RemoveProductDetailsEvent) _then;

/// Create a copy of ProductEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? transactionId = null,}) {
  return _then(RemoveProductDetailsEvent(
transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
