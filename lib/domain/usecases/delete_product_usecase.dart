import 'package:trucky/core/usecase/usecase.dart';
import 'package:trucky/core/utils/result.dart';
import 'package:trucky/core/utils/typedefs.dart';
import 'package:trucky/domain/repositories/product_repository.dart';

/// Removes a product and (via FK cascade) all of its transactions.
class DeleteProductUsecase extends UseCase<int, Result<void>> {
  const DeleteProductUsecase(this._repository);

  final ProductRepository _repository;

  @override
  ResultFuture<void> call(int id) {
    return _repository.deleteProduct(id);
  }
}
