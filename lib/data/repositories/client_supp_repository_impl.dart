import 'package:trucky/core/errors/failures.dart';
import 'package:trucky/core/utils/result.dart';
import 'package:trucky/data/datasources/local/client_supp_local_data_source.dart';
import 'package:trucky/data/models/client_supp_model.dart';
import 'package:trucky/data/models/client_supp_txn_model.dart';
import 'package:trucky/domain/entities/client_supp_entity.dart';
import 'package:trucky/domain/entities/client_supp_txn_entity.dart';
import 'package:trucky/domain/repositories/client_supp_repository.dart';

class ClientSuppRepositoryImpl implements ClientSuppRepository {
  ClientSuppRepositoryImpl({required ClientSuppLocalDataSource local})
    : _local = local;

  final ClientSuppLocalDataSource _local;

  @override
  Future<Result<List<ClientSuppEntity>>> fetchAllClientSupps() async {
    try {
      final rows = await _local.fetchAllClientSupps();
      return Result.success(rows.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Result.failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<ClientSuppTxnEntity>>> fetchAllClientSuppTxns() async {
    try {
      final rows = await _local.fetchAllClientSuppTxns();
      return Result.success(rows.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Result.failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<int>> addClientSupp(ClientSuppEntity entity) async {
    try {
      final id = await _local.insertClientSupp(
        ClientSuppModel.fromEntity(entity),
      );
      return Result.success(id);
    } catch (e) {
      return Result.failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<int>> updateClientSupp(ClientSuppEntity entity) async {
    try {
      final updated = await _local.updateClientSupp(
        ClientSuppModel.fromEntity(entity),
      );
      return Result.success(updated);
    } catch (e) {
      return Result.failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<int>> deleteClientSupp(int id) async {
    try {
      final deleted = await _local.deleteClientSupp(id);
      return Result.success(deleted);
    } catch (e) {
      return Result.failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<int>> addClientSuppTxn(ClientSuppTxnEntity txn) async {
    try {
      final id = await _local.insertClientSuppTxn(
        ClientSuppTxnModel.fromEntity(txn),
      );
      return Result.success(id);
    } catch (e) {
      return Result.failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<int>> deleteClientSuppTxn(int txnId) async {
    try {
      final deleted = await _local.deleteClientSuppTxn(txnId);
      return Result.success(deleted);
    } catch (e) {
      return Result.failure(CacheFailure(e.toString()));
    }
  }
}
