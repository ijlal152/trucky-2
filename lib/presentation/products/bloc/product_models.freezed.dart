// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Product {

 String? get id; String get productName; double get purchasePrice; double get sellingPrice; double get availableStock; String? get quantityPerPackage; String? get productImage; String? get productSKU; double? get weightedAverageCost; DateTime? get createdAt;/// Authoritative WAC from the snapshot (preferred over purchasePrice).
 double? get averageCost;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, id) || other.id == id)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.purchasePrice, purchasePrice) || other.purchasePrice == purchasePrice)&&(identical(other.sellingPrice, sellingPrice) || other.sellingPrice == sellingPrice)&&(identical(other.availableStock, availableStock) || other.availableStock == availableStock)&&(identical(other.quantityPerPackage, quantityPerPackage) || other.quantityPerPackage == quantityPerPackage)&&(identical(other.productImage, productImage) || other.productImage == productImage)&&(identical(other.productSKU, productSKU) || other.productSKU == productSKU)&&(identical(other.weightedAverageCost, weightedAverageCost) || other.weightedAverageCost == weightedAverageCost)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.averageCost, averageCost) || other.averageCost == averageCost));
}


@override
int get hashCode => Object.hash(runtimeType,id,productName,purchasePrice,sellingPrice,availableStock,quantityPerPackage,productImage,productSKU,weightedAverageCost,createdAt,averageCost);

@override
String toString() {
  return 'Product(id: $id, productName: $productName, purchasePrice: $purchasePrice, sellingPrice: $sellingPrice, availableStock: $availableStock, quantityPerPackage: $quantityPerPackage, productImage: $productImage, productSKU: $productSKU, weightedAverageCost: $weightedAverageCost, createdAt: $createdAt, averageCost: $averageCost)';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 String? id, String productName, double purchasePrice, double sellingPrice, double availableStock, String? quantityPerPackage, String? productImage, String? productSKU, double? weightedAverageCost, DateTime? createdAt, double? averageCost
});




}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? productName = null,Object? purchasePrice = null,Object? sellingPrice = null,Object? availableStock = null,Object? quantityPerPackage = freezed,Object? productImage = freezed,Object? productSKU = freezed,Object? weightedAverageCost = freezed,Object? createdAt = freezed,Object? averageCost = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,purchasePrice: null == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as double,sellingPrice: null == sellingPrice ? _self.sellingPrice : sellingPrice // ignore: cast_nullable_to_non_nullable
as double,availableStock: null == availableStock ? _self.availableStock : availableStock // ignore: cast_nullable_to_non_nullable
as double,quantityPerPackage: freezed == quantityPerPackage ? _self.quantityPerPackage : quantityPerPackage // ignore: cast_nullable_to_non_nullable
as String?,productImage: freezed == productImage ? _self.productImage : productImage // ignore: cast_nullable_to_non_nullable
as String?,productSKU: freezed == productSKU ? _self.productSKU : productSKU // ignore: cast_nullable_to_non_nullable
as String?,weightedAverageCost: freezed == weightedAverageCost ? _self.weightedAverageCost : weightedAverageCost // ignore: cast_nullable_to_non_nullable
as double?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,averageCost: freezed == averageCost ? _self.averageCost : averageCost // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String productName,  double purchasePrice,  double sellingPrice,  double availableStock,  String? quantityPerPackage,  String? productImage,  String? productSKU,  double? weightedAverageCost,  DateTime? createdAt,  double? averageCost)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.productName,_that.purchasePrice,_that.sellingPrice,_that.availableStock,_that.quantityPerPackage,_that.productImage,_that.productSKU,_that.weightedAverageCost,_that.createdAt,_that.averageCost);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String productName,  double purchasePrice,  double sellingPrice,  double availableStock,  String? quantityPerPackage,  String? productImage,  String? productSKU,  double? weightedAverageCost,  DateTime? createdAt,  double? averageCost)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.productName,_that.purchasePrice,_that.sellingPrice,_that.availableStock,_that.quantityPerPackage,_that.productImage,_that.productSKU,_that.weightedAverageCost,_that.createdAt,_that.averageCost);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String productName,  double purchasePrice,  double sellingPrice,  double availableStock,  String? quantityPerPackage,  String? productImage,  String? productSKU,  double? weightedAverageCost,  DateTime? createdAt,  double? averageCost)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.productName,_that.purchasePrice,_that.sellingPrice,_that.availableStock,_that.quantityPerPackage,_that.productImage,_that.productSKU,_that.weightedAverageCost,_that.createdAt,_that.averageCost);case _:
  return null;

}
}

}

/// @nodoc


class _Product extends Product {
  const _Product({this.id, required this.productName, required this.purchasePrice, required this.sellingPrice, this.availableStock = 0, this.quantityPerPackage, this.productImage, this.productSKU, this.weightedAverageCost, this.createdAt, this.averageCost}): super._();
  

@override final  String? id;
@override final  String productName;
@override final  double purchasePrice;
@override final  double sellingPrice;
@override@JsonKey() final  double availableStock;
@override final  String? quantityPerPackage;
@override final  String? productImage;
@override final  String? productSKU;
@override final  double? weightedAverageCost;
@override final  DateTime? createdAt;
/// Authoritative WAC from the snapshot (preferred over purchasePrice).
@override final  double? averageCost;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.purchasePrice, purchasePrice) || other.purchasePrice == purchasePrice)&&(identical(other.sellingPrice, sellingPrice) || other.sellingPrice == sellingPrice)&&(identical(other.availableStock, availableStock) || other.availableStock == availableStock)&&(identical(other.quantityPerPackage, quantityPerPackage) || other.quantityPerPackage == quantityPerPackage)&&(identical(other.productImage, productImage) || other.productImage == productImage)&&(identical(other.productSKU, productSKU) || other.productSKU == productSKU)&&(identical(other.weightedAverageCost, weightedAverageCost) || other.weightedAverageCost == weightedAverageCost)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.averageCost, averageCost) || other.averageCost == averageCost));
}


@override
int get hashCode => Object.hash(runtimeType,id,productName,purchasePrice,sellingPrice,availableStock,quantityPerPackage,productImage,productSKU,weightedAverageCost,createdAt,averageCost);

@override
String toString() {
  return 'Product(id: $id, productName: $productName, purchasePrice: $purchasePrice, sellingPrice: $sellingPrice, availableStock: $availableStock, quantityPerPackage: $quantityPerPackage, productImage: $productImage, productSKU: $productSKU, weightedAverageCost: $weightedAverageCost, createdAt: $createdAt, averageCost: $averageCost)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 String? id, String productName, double purchasePrice, double sellingPrice, double availableStock, String? quantityPerPackage, String? productImage, String? productSKU, double? weightedAverageCost, DateTime? createdAt, double? averageCost
});




}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? productName = null,Object? purchasePrice = null,Object? sellingPrice = null,Object? availableStock = null,Object? quantityPerPackage = freezed,Object? productImage = freezed,Object? productSKU = freezed,Object? weightedAverageCost = freezed,Object? createdAt = freezed,Object? averageCost = freezed,}) {
  return _then(_Product(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,purchasePrice: null == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as double,sellingPrice: null == sellingPrice ? _self.sellingPrice : sellingPrice // ignore: cast_nullable_to_non_nullable
as double,availableStock: null == availableStock ? _self.availableStock : availableStock // ignore: cast_nullable_to_non_nullable
as double,quantityPerPackage: freezed == quantityPerPackage ? _self.quantityPerPackage : quantityPerPackage // ignore: cast_nullable_to_non_nullable
as String?,productImage: freezed == productImage ? _self.productImage : productImage // ignore: cast_nullable_to_non_nullable
as String?,productSKU: freezed == productSKU ? _self.productSKU : productSKU // ignore: cast_nullable_to_non_nullable
as String?,weightedAverageCost: freezed == weightedAverageCost ? _self.weightedAverageCost : weightedAverageCost // ignore: cast_nullable_to_non_nullable
as double?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,averageCost: freezed == averageCost ? _self.averageCost : averageCost // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

/// @nodoc
mixin _$ProductDetail {

 String get productId; String? get sourceName; String? get sourceType; double get purchasePrice; double get sellingPrice; double get quantity; String get paymentType; DateTime get createdAt;/// Shared id linking this detail to its parent transaction, if any.
 String? get transactionId; String? get quantityPerPackage;
/// Create a copy of ProductDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductDetailCopyWith<ProductDetail> get copyWith => _$ProductDetailCopyWithImpl<ProductDetail>(this as ProductDetail, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductDetail&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.sourceName, sourceName) || other.sourceName == sourceName)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.purchasePrice, purchasePrice) || other.purchasePrice == purchasePrice)&&(identical(other.sellingPrice, sellingPrice) || other.sellingPrice == sellingPrice)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.paymentType, paymentType) || other.paymentType == paymentType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.quantityPerPackage, quantityPerPackage) || other.quantityPerPackage == quantityPerPackage));
}


@override
int get hashCode => Object.hash(runtimeType,productId,sourceName,sourceType,purchasePrice,sellingPrice,quantity,paymentType,createdAt,transactionId,quantityPerPackage);

@override
String toString() {
  return 'ProductDetail(productId: $productId, sourceName: $sourceName, sourceType: $sourceType, purchasePrice: $purchasePrice, sellingPrice: $sellingPrice, quantity: $quantity, paymentType: $paymentType, createdAt: $createdAt, transactionId: $transactionId, quantityPerPackage: $quantityPerPackage)';
}


}

/// @nodoc
abstract mixin class $ProductDetailCopyWith<$Res>  {
  factory $ProductDetailCopyWith(ProductDetail value, $Res Function(ProductDetail) _then) = _$ProductDetailCopyWithImpl;
@useResult
$Res call({
 String productId, String? sourceName, String? sourceType, double purchasePrice, double sellingPrice, double quantity, String paymentType, DateTime createdAt, String? transactionId, String? quantityPerPackage
});




}
/// @nodoc
class _$ProductDetailCopyWithImpl<$Res>
    implements $ProductDetailCopyWith<$Res> {
  _$ProductDetailCopyWithImpl(this._self, this._then);

  final ProductDetail _self;
  final $Res Function(ProductDetail) _then;

/// Create a copy of ProductDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? sourceName = freezed,Object? sourceType = freezed,Object? purchasePrice = null,Object? sellingPrice = null,Object? quantity = null,Object? paymentType = null,Object? createdAt = null,Object? transactionId = freezed,Object? quantityPerPackage = freezed,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,sourceName: freezed == sourceName ? _self.sourceName : sourceName // ignore: cast_nullable_to_non_nullable
as String?,sourceType: freezed == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as String?,purchasePrice: null == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as double,sellingPrice: null == sellingPrice ? _self.sellingPrice : sellingPrice // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,paymentType: null == paymentType ? _self.paymentType : paymentType // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,quantityPerPackage: freezed == quantityPerPackage ? _self.quantityPerPackage : quantityPerPackage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductDetail].
extension ProductDetailPatterns on ProductDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductDetail value)  $default,){
final _that = this;
switch (_that) {
case _ProductDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductDetail value)?  $default,){
final _that = this;
switch (_that) {
case _ProductDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  String? sourceName,  String? sourceType,  double purchasePrice,  double sellingPrice,  double quantity,  String paymentType,  DateTime createdAt,  String? transactionId,  String? quantityPerPackage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductDetail() when $default != null:
return $default(_that.productId,_that.sourceName,_that.sourceType,_that.purchasePrice,_that.sellingPrice,_that.quantity,_that.paymentType,_that.createdAt,_that.transactionId,_that.quantityPerPackage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  String? sourceName,  String? sourceType,  double purchasePrice,  double sellingPrice,  double quantity,  String paymentType,  DateTime createdAt,  String? transactionId,  String? quantityPerPackage)  $default,) {final _that = this;
switch (_that) {
case _ProductDetail():
return $default(_that.productId,_that.sourceName,_that.sourceType,_that.purchasePrice,_that.sellingPrice,_that.quantity,_that.paymentType,_that.createdAt,_that.transactionId,_that.quantityPerPackage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  String? sourceName,  String? sourceType,  double purchasePrice,  double sellingPrice,  double quantity,  String paymentType,  DateTime createdAt,  String? transactionId,  String? quantityPerPackage)?  $default,) {final _that = this;
switch (_that) {
case _ProductDetail() when $default != null:
return $default(_that.productId,_that.sourceName,_that.sourceType,_that.purchasePrice,_that.sellingPrice,_that.quantity,_that.paymentType,_that.createdAt,_that.transactionId,_that.quantityPerPackage);case _:
  return null;

}
}

}

/// @nodoc


class _ProductDetail extends ProductDetail {
  const _ProductDetail({required this.productId, this.sourceName, this.sourceType, required this.purchasePrice, required this.sellingPrice, required this.quantity, required this.paymentType, required this.createdAt, this.transactionId, this.quantityPerPackage}): super._();
  

@override final  String productId;
@override final  String? sourceName;
@override final  String? sourceType;
@override final  double purchasePrice;
@override final  double sellingPrice;
@override final  double quantity;
@override final  String paymentType;
@override final  DateTime createdAt;
/// Shared id linking this detail to its parent transaction, if any.
@override final  String? transactionId;
@override final  String? quantityPerPackage;

/// Create a copy of ProductDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductDetailCopyWith<_ProductDetail> get copyWith => __$ProductDetailCopyWithImpl<_ProductDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductDetail&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.sourceName, sourceName) || other.sourceName == sourceName)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.purchasePrice, purchasePrice) || other.purchasePrice == purchasePrice)&&(identical(other.sellingPrice, sellingPrice) || other.sellingPrice == sellingPrice)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.paymentType, paymentType) || other.paymentType == paymentType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.quantityPerPackage, quantityPerPackage) || other.quantityPerPackage == quantityPerPackage));
}


@override
int get hashCode => Object.hash(runtimeType,productId,sourceName,sourceType,purchasePrice,sellingPrice,quantity,paymentType,createdAt,transactionId,quantityPerPackage);

@override
String toString() {
  return 'ProductDetail(productId: $productId, sourceName: $sourceName, sourceType: $sourceType, purchasePrice: $purchasePrice, sellingPrice: $sellingPrice, quantity: $quantity, paymentType: $paymentType, createdAt: $createdAt, transactionId: $transactionId, quantityPerPackage: $quantityPerPackage)';
}


}

/// @nodoc
abstract mixin class _$ProductDetailCopyWith<$Res> implements $ProductDetailCopyWith<$Res> {
  factory _$ProductDetailCopyWith(_ProductDetail value, $Res Function(_ProductDetail) _then) = __$ProductDetailCopyWithImpl;
@override @useResult
$Res call({
 String productId, String? sourceName, String? sourceType, double purchasePrice, double sellingPrice, double quantity, String paymentType, DateTime createdAt, String? transactionId, String? quantityPerPackage
});




}
/// @nodoc
class __$ProductDetailCopyWithImpl<$Res>
    implements _$ProductDetailCopyWith<$Res> {
  __$ProductDetailCopyWithImpl(this._self, this._then);

  final _ProductDetail _self;
  final $Res Function(_ProductDetail) _then;

/// Create a copy of ProductDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? sourceName = freezed,Object? sourceType = freezed,Object? purchasePrice = null,Object? sellingPrice = null,Object? quantity = null,Object? paymentType = null,Object? createdAt = null,Object? transactionId = freezed,Object? quantityPerPackage = freezed,}) {
  return _then(_ProductDetail(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,sourceName: freezed == sourceName ? _self.sourceName : sourceName // ignore: cast_nullable_to_non_nullable
as String?,sourceType: freezed == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as String?,purchasePrice: null == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as double,sellingPrice: null == sellingPrice ? _self.sellingPrice : sellingPrice // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,paymentType: null == paymentType ? _self.paymentType : paymentType // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,quantityPerPackage: freezed == quantityPerPackage ? _self.quantityPerPackage : quantityPerPackage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
