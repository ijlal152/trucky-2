import 'package:trucky/core/usecase/usecase.dart';
import 'package:trucky/core/utils/result.dart';
import 'package:trucky/core/utils/typedefs.dart';
import 'package:trucky/domain/repositories/product_repository.dart';

/// Removes every inventory ledger row belonging to a transaction. Returns the
/// distinct product ids whose rows were removed (for snapshot rebuilds).
class DeleteTransactionsByTransactionIdUsecase
    extends UseCase<String, Result<List<int>>> {
  const DeleteTransactionsByTransactionIdUsecase(this._repository);

  final ProductRepository _repository;

  @override
  ResultFuture<List<int>> call(String transactionId) {
    return _repository.deleteTransactionsByTransactionId(transactionId);
  }
}