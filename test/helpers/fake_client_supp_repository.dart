import 'package:trucky/core/utils/result.dart';
import 'package:trucky/domain/entities/client_supp_entity.dart';
import 'package:trucky/domain/entities/client_supp_txn_entity.dart';
import 'package:trucky/domain/repositories/client_supp_repository.dart';
import 'package:trucky/domain/usecases/add_client_supp_txn_usecase.dart';
import 'package:trucky/domain/usecases/add_client_supp_usecase.dart';
import 'package:trucky/domain/usecases/delete_client_supp_txn_usecase.dart';
import 'package:trucky/domain/usecases/fetch_all_client_supp_txn_usecase.dart';
import 'package:trucky/domain/usecases/fetch_all_client_supp_usecase.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_bloc.dart';

/// In-memory [ClientSuppRepository] that seeds the same sample data the old
/// mock bloc used, so widget/bloc tests keep passing without a real DB.
class FakeClientSuppRepository implements ClientSuppRepository {
  FakeClientSuppRepository() {
    _seed();
  }

  final List<ClientSuppEntity> _entities = [];
  final List<ClientSuppTxnEntity> _txns = [];
  int _nextEntityId = 1;
  int _nextTxnId = 1;

  void _seed() {
    final now = DateTime.now();
    _entities.addAll([
      ClientSuppEntity(
        id: 1,
        userId: 1,
        name: 'Ahmed Benali',
        role: 'client',
        phoneNumber: '0551000000',
        gpsLocation: '36.710382, 3.199882',
        createdAt: now.subtract(const Duration(days: 9)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      ClientSuppEntity(
        id: 2,
        userId: 1,
        name: 'Sara Haddad',
        role: 'client',
        phoneNumber: '0551111111',
        gpsLocation: '36.710382, 3.199882',
        createdAt: now.subtract(const Duration(days: 6)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      ClientSuppEntity(
        id: 3,
        userId: 1,
        name: 'Karim Meziane',
        role: 'client',
        phoneNumber: '0552222222',
        gpsLocation: '36.710382, 3.199882',
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
      ClientSuppEntity(
        id: 4,
        userId: 1,
        name: 'Lina Bouzid',
        role: 'client',
        phoneNumber: '0553333333',
        gpsLocation: '36.710382, 3.199882',
        createdAt: now,
        updatedAt: now,
      ),
      ClientSuppEntity(
        id: 5,
        userId: 1,
        name: 'Global Traders',
        role: 'supplier',
        phoneNumber: '0772000000',
        gpsLocation: '36.7525, 3.0420',
        createdAt: now.subtract(const Duration(days: 4)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      ClientSuppEntity(
        id: 6,
        userId: 1,
        name: 'Algeria Auto Parts',
        role: 'supplier',
        phoneNumber: '0772222222',
        gpsLocation: '36.7525, 3.0420',
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      ClientSuppEntity(
        id: 7,
        userId: 1,
        name: 'Mediterranean Supply',
        role: 'supplier',
        phoneNumber: '0774444444',
        gpsLocation: '36.7525, 3.0420',
        createdAt: now,
        updatedAt: now,
      ),
    ]);
    _nextEntityId = 8;

    _txns.addAll([
      ClientSuppTxnEntity(
        id: 1,
        userId: 1,
        clientSuppId: 1,
        transactionId: 'txn-1',
        clientSupplierName: 'Ahmed Benali',
        role: 'client',
        txnData: now.subtract(const Duration(days: 10)),
        amount: '1200',
        paymentType: 'Initial Balance',
      ),
      ClientSuppTxnEntity(
        id: 2,
        userId: 1,
        clientSuppId: 2,
        transactionId: 'txn-2',
        clientSupplierName: 'Sara Haddad',
        role: 'client',
        txnData: now.subtract(const Duration(days: 8)),
        amount: '800',
        paymentType: 'Initial Balance',
      ),
      ClientSuppTxnEntity(
        id: 3,
        userId: 1,
        clientSuppId: 5,
        transactionId: 'txn-3',
        clientSupplierName: 'Global Traders',
        role: 'supplier',
        txnData: now.subtract(const Duration(days: 9)),
        amount: '2000',
        paymentType: 'Initial Balance',
      ),
      ClientSuppTxnEntity(
        id: 4,
        userId: 1,
        clientSuppId: 1,
        transactionId: 'txn-4',
        clientSupplierName: 'Ahmed Benali',
        role: 'client',
        txnData: now.subtract(const Duration(days: 2)),
        amount: '300',
        paymentType: 'Payment',
      ),
      ClientSuppTxnEntity(
        id: 5,
        userId: 1,
        clientSuppId: 6,
        transactionId: 'txn-5',
        clientSupplierName: 'Algeria Auto Parts',
        role: 'supplier',
        txnData: now.subtract(const Duration(days: 6)),
        amount: '500',
        paymentType: 'Initial Balance',
      ),
    ]);
    _nextTxnId = 6;
  }

  @override
  Future<Result<List<ClientSuppEntity>>> fetchAllClientSupps() async {
    return Result.success(List.of(_entities));
  }

  @override
  Future<Result<List<ClientSuppTxnEntity>>> fetchAllClientSuppTxns() async {
    return Result.success(List.of(_txns));
  }

  @override
  Future<Result<int>> addClientSupp(ClientSuppEntity entity) async {
    final id = _nextEntityId++;
    _entities.add(
      ClientSuppEntity(
        id: id,
        userId: entity.userId,
        name: entity.name,
        role: entity.role,
        phoneNumber: entity.phoneNumber,
        gpsLocation: entity.gpsLocation,
        isSynced: entity.isSynced,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      ),
    );
    return Result.success(id);
  }

  @override
  Future<Result<int>> updateClientSupp(ClientSuppEntity entity) async {
    final index = _entities.indexWhere((e) => e.id == entity.id);
    if (index >= 0) _entities[index] = entity;
    return Result.success(index >= 0 ? 1 : 0);
  }

  @override
  Future<Result<int>> deleteClientSupp(int id) async {
    _entities.removeWhere((e) => e.id == id);
    _txns.removeWhere((t) => t.clientSuppId == id);
    return Result.success(1);
  }

  @override
  Future<Result<int>> addClientSuppTxn(ClientSuppTxnEntity txn) async {
    final id = _nextTxnId++;
    _txns.add(
      ClientSuppTxnEntity(
        id: id,
        userId: txn.userId,
        clientSuppId: txn.clientSuppId,
        transactionId: txn.transactionId,
        clientSupplierName: txn.clientSupplierName,
        role: txn.role,
        txnData: txn.txnData,
        discountAmount: txn.discountAmount,
        amount: txn.amount,
        paymentType: txn.paymentType,
        note: txn.note,
        isSynced: txn.isSynced,
      ),
    );
    return Result.success(id);
  }

  @override
  Future<Result<int>> deleteClientSuppTxn(int txnId) async {
    _txns.removeWhere((t) => t.id == txnId);
    return Result.success(1);
  }
}

/// Builds a [ClientSuppBloc] backed by a fresh [FakeClientSuppRepository].
ClientSuppBloc buildClientSuppBloc([FakeClientSuppRepository? repository]) {
  final repo = repository ?? FakeClientSuppRepository();
  return ClientSuppBloc(
    fetchAllClientSupps: FetchAllClientSuppUsecase(repo),
    fetchAllClientSuppTxns: FetchAllClientSuppTxnUsecase(repo),
    addClientSupp: AddClientSuppUsecase(repo),
    addClientSuppTxn: AddClientSuppTxnUsecase(repo),
    deleteClientSuppTxn: DeleteClientSuppTxnUsecase(repo),
  );
}
