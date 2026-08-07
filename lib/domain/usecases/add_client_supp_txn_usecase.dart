import 'package:trucky/core/usecase/usecase.dart';
import 'package:trucky/core/utils/result.dart';
import 'package:trucky/core/utils/typedefs.dart';
import 'package:trucky/domain/entities/client_supp_txn_entity.dart';
import 'package:trucky/domain/repositories/client_supp_repository.dart';

/// Records a transaction against a client/supplier.
class AddClientSuppTxnUsecase
    extends UseCase<ClientSuppTxnEntity, Result<int>> {
  const AddClientSuppTxnUsecase(this._repository);

  final ClientSuppRepository _repository;

  @override
  ResultFuture<int> call(ClientSuppTxnEntity txn) {
    return _repository.addClientSuppTxn(txn);
  }
}
