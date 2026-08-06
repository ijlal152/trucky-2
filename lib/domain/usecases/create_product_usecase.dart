import 'package:trucky/core/usecase/usecase.dart';
import 'package:trucky/core/utils/result.dart';
import 'package:trucky/core/utils/typedefs.dart';
import 'package:trucky/domain/entities/product_entity.dart';
import 'package:trucky/domain/repositories/product_repository.dart';

/// Input for [CreateProductUsecase].
class CreateProductUsecase
    extends UseCase<CreateProductParams, Result<ProductEntity>> {
  const CreateProductUsecase(this._repository);

  final ProductRepository _repository;

  @override
  ResultFuture<ProductEntity> call(CreateProductParams params) {
    return _repository.createProduct(
      name: params.name,
      sku: params.sku,
      sellingPrice: params.sellingPrice,
      initialQuantity: params.initialQuantity,
      initialPurchasePrice: params.initialPurchasePrice,
    );
  }
}

class CreateProductParams {
  const CreateProductParams({
    required this.name,
    required this.sku,
    required this.sellingPrice,
    required this.initialQuantity,
    required this.initialPurchasePrice,
  });

  final String name;
  final String sku;
  final double sellingPrice;
  final double initialQuantity;
  final double initialPurchasePrice;
}
