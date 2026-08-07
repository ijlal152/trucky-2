import 'package:trucky/core/utils/result.dart';
import 'package:trucky/domain/entities/client_supp_entity.dart';
import 'package:trucky/domain/entities/client_supp_txn_entity.dart';

/// Domain-level contract for client & supplier operations.
///
/// Repositories return [Result] instead of throwing; data sources may throw
/// low-level exceptions which the implementation translates into failures.
abstract interface class ClientSuppRepository {
  /// Returns all clients & suppliers, ordered by creation time ascending.
  Future<Result<List<ClientSuppEntity>>> fetchAllClientSupps();

  /// Returns every client/supplier transaction, ordered by date ascending.
  Future<Result<List<ClientSuppTxnEntity>>> fetchAllClientSuppTxns();

  /// Creates a new client/supplier. Returns the generated row id.
  Future<Result<int>> addClientSupp(ClientSuppEntity entity);

  /// Updates an existing client/supplier. Returns the number of rows changed.
  Future<Result<int>> updateClientSupp(ClientSuppEntity entity);

  /// Removes a client/supplier and (via FK cascade) all of its transactions.
  Future<Result<int>> deleteClientSupp(int id);

  /// Records a transaction against a client/supplier. Returns the row id.
  Future<Result<int>> addClientSuppTxn(ClientSuppTxnEntity txn);

  /// Removes a single client/supplier transaction.
  Future<Result<int>> deleteClientSuppTxn(int txnId);
}