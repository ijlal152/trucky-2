import 'package:trucky/core/usecase/usecase.dart';
import 'package:trucky/core/utils/result.dart';
import 'package:trucky/core/utils/typedefs.dart';
import 'package:trucky/domain/entities/product_entity.dart';
import 'package:trucky/domain/repositories/product_repository.dart';
import 'package:trucky/domain/usecases/record_transaction_params.dart';

/// Records a purchase, blending new stock into the existing WAC.
class RecordPurchaseUsecase
    extends UseCase<RecordTransactionParams, Result<ProductEntity>> {
  const RecordPurchaseUsecase(this._repository);

  final ProductRepository _repository;

  @override
  ResultFuture<ProductEntity> call(RecordTransactionParams params) {
    return _repository.recordPurchase(
      productId: params.productId,
      quantity: params.quantity,
      unitPrice: params.unitPrice,
      sourceName: params.sourceName,
      sourceType: params.sourceType,
      transactionId: params.transactionId,
      quantityPerPackage: params.quantityPerPackage,
    );
  }
}
