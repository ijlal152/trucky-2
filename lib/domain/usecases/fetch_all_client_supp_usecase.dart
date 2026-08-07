import 'package:trucky/core/usecase/usecase.dart';
import 'package:trucky/core/utils/result.dart';
import 'package:trucky/core/utils/typedefs.dart';
import 'package:trucky/domain/entities/client_supp_entity.dart';
import 'package:trucky/domain/repositories/client_supp_repository.dart';

/// Loads every client & supplier, ordered by creation time ascending.
class FetchAllClientSuppUsecase
    extends UseCase<NoParams, Result<List<ClientSuppEntity>>> {
  const FetchAllClientSuppUsecase(this._repository);

  final ClientSuppRepository _repository;

  @override
  ResultFuture<List<ClientSuppEntity>> call(NoParams params) {
    return _repository.fetchAllClientSupps();
  }
}
