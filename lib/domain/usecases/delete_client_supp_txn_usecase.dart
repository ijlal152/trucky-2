import 'package:trucky/core/usecase/usecase.dart';
import 'package:trucky/core/utils/result.dart';
import 'package:trucky/core/utils/typedefs.dart';
import 'package:trucky/domain/repositories/client_supp_repository.dart';

/// Removes a single client/supplier transaction.
class DeleteClientSuppTxnUsecase extends UseCase<int, Result<int>> {
  const DeleteClientSuppTxnUsecase(this._repository);

  final ClientSuppRepository _repository;

  @override
  ResultFuture<int> call(int txnId) {
    return _repository.deleteClientSuppTxn(txnId);
  }
}
