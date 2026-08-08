import 'package:trucky/core/usecase/usecase.dart';
import 'package:trucky/core/utils/result.dart';
import 'package:trucky/core/utils/typedefs.dart';
import 'package:trucky/domain/entities/product_transaction_entity.dart';
import 'package:trucky/domain/repositories/product_repository.dart';

/// Returns the full transaction history for a product, newest first.
class GetProductTransactionsUsecase
    extends UseCase<int, Result<List<ProductTransactionEntity>>> {
  const GetProductTransactionsUsecase(this._repository);

  final ProductRepository _repository;

  @override
  ResultFuture<List<ProductTransactionEntity>> call(int productId) {
    return _repository.getTransactionsForProduct(productId);
  }
}
