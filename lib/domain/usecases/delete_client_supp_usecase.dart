import 'package:trucky/core/usecase/usecase.dart';
import 'package:trucky/core/utils/result.dart';
import 'package:trucky/core/utils/typedefs.dart';
import 'package:trucky/domain/repositories/client_supp_repository.dart';

/// Removes a client/supplier and (via FK cascade) all of its transactions.
class DeleteClientSuppUsecase extends UseCase<int, Result<int>> {
  const DeleteClientSuppUsecase(this._repository);

  final ClientSuppRepository _repository;

  @override
  ResultFuture<int> call(int id) {
    return _repository.deleteClientSupp(id);
  }
}
