import 'package:trucky/core/usecase/usecase.dart';
import 'package:trucky/core/utils/result.dart';
import 'package:trucky/core/utils/typedefs.dart';
import 'package:trucky/domain/entities/client_supp_entity.dart';
import 'package:trucky/domain/repositories/client_supp_repository.dart';

/// Updates an existing client/supplier.
class UpdateClientSuppUsecase extends UseCase<ClientSuppEntity, Result<int>> {
  const UpdateClientSuppUsecase(this._repository);

  final ClientSuppRepository _repository;

  @override
  ResultFuture<int> call(ClientSuppEntity entity) {
    return _repository.updateClientSupp(entity);
  }
}
