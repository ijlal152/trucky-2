import 'package:trucky/core/usecase/usecase.dart';
import 'package:trucky/core/utils/result.dart';
import 'package:trucky/core/utils/typedefs.dart';
import 'package:trucky/domain/entities/product_entity.dart';
import 'package:trucky/domain/repositories/product_repository.dart';

/// Replays the remaining ledger for the given products and writes recomputed
/// snapshots. Returns the rebuilt product entities.
class RebuildSnapshotsForProductsUsecase
    extends UseCase<List<int>, Result<List<ProductEntity>>> {
  const RebuildSnapshotsForProductsUsecase(this._repository);

  final ProductRepository _repository;

  @override
  ResultFuture<List<ProductEntity>> call(List<int> productIds) {
    return _repository.rebuildSnapshotsForProducts(productIds);
  }
}