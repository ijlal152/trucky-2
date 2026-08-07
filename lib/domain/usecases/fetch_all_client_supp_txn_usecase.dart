import 'package:trucky/core/usecase/usecase.dart';
import 'package:trucky/core/utils/result.dart';
import 'package:trucky/core/utils/typedefs.dart';
import 'package:trucky/domain/entities/client_supp_txn_entity.dart';
import 'package:trucky/domain/repositories/client_supp_repository.dart';

/// Loads every client/supplier transaction, ordered by date ascending.
class FetchAllClientSuppTxnUsecase
    extends UseCase<NoParams, Result<List<ClientSuppTxnEntity>>> {
  const FetchAllClientSuppTxnUsecase(this._repository);

  final ClientSuppRepository _repository;

  @override
  ResultFuture<List<ClientSuppTxnEntity>> call(NoParams params) {
    return _repository.fetchAllClientSuppTxns();
  }
}
