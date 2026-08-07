import 'package:trucky/core/usecase/usecase.dart';
import 'package:trucky/core/utils/result.dart';
import 'package:trucky/core/utils/typedefs.dart';
import 'package:trucky/domain/entities/client_supp_entity.dart';
import 'package:trucky/domain/repositories/client_supp_repository.dart';

/// Creates a new client or supplier. Returns the generated row id.
class AddClientSuppUsecase extends UseCase<ClientSuppEntity, Result<int>> {
  const AddClientSuppUsecase(this._repository);

  final ClientSuppRepository _repository;

  @override
  ResultFuture<int> call(ClientSuppEntity entity) {
    return _repository.addClientSupp(entity);
  }
}
