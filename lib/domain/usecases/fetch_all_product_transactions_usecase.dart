import 'package:trucky/core/usecase/usecase.dart';
import 'package:trucky/core/utils/result.dart';
import 'package:trucky/core/utils/typedefs.dart';
import 'package:trucky/domain/entities/product_transaction_entity.dart';
import 'package:trucky/domain/repositories/product_repository.dart';

/// Loads every inventory ledger row across all products, ordered by date
/// ascending. Used to join a transaction's products back from the database
/// by `transactionId` (mirrors the legacy `load_app_data` join).
class FetchAllProductTransactionsUsecase
    extends UseCase<NoParams, Result<List<ProductTransactionEntity>>> {
  const FetchAllProductTransactionsUsecase(this._repository);

  final ProductRepository _repository;

  @override
  ResultFuture<List<ProductTransactionEntity>> call(NoParams params) {
    return _repository.getAllProductTransactions();
  }
}
