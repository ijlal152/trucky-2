import 'package:trucky/core/usecase/usecase.dart';
import 'package:trucky/core/utils/result.dart';
import 'package:trucky/core/utils/typedefs.dart';
import 'package:trucky/domain/entities/product_entity.dart';
import 'package:trucky/domain/repositories/product_repository.dart';

/// Loads every product snapshot, ordered by creation time ascending.
class GetAllProductsUsecase
    extends UseCase<NoParams, Result<List<ProductEntity>>> {
  const GetAllProductsUsecase(this._repository);

  final ProductRepository _repository;

  @override
  ResultFuture<List<ProductEntity>> call(NoParams params) {
    return _repository.getAllProducts();
  }
}
