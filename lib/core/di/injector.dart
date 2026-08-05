import 'package:trucky/core/network/api_client.dart';
import 'package:trucky/core/network/mock_api_client.dart';
import 'package:trucky/core/network/network_info.dart';
import 'package:trucky/data/datasources/local/product_local_data_source.dart';
import 'package:trucky/data/repositories/product_repository_impl.dart';
import 'package:trucky/domain/repositories/product_repository.dart';
import 'package:trucky/domain/usecases/create_product_usecase.dart';
import 'package:trucky/domain/usecases/delete_product_usecase.dart';
import 'package:trucky/domain/usecases/get_all_products_usecase.dart';
import 'package:trucky/domain/usecases/get_product_transactions_usecase.dart';
import 'package:trucky/domain/usecases/record_purchase_usecase.dart';
import 'package:trucky/domain/usecases/record_return_usecase.dart';
import 'package:trucky/domain/usecases/record_sale_usecase.dart';

/// Global composition root: provides shared infrastructure to every feature.
///
/// Blocs receive these as constructor dependencies. Swap `MockApiClient` for
/// a real client here and the whole app switches over.
abstract final class Injector {
  static final ApiClient apiClient = const MockApiClient();

  static final NetworkInfo networkInfo = const NetworkInfoImpl();

  // ---------------- Inventory / Product module ----------------

  static final ProductLocalDataSource productLocalDataSource =
      ProductLocalDataSource();

  static final ProductRepository productRepository = ProductRepositoryImpl(
    local: productLocalDataSource,
  );

  // ---------------- Product use cases ----------------

  static final GetAllProductsUsecase getAllProductsUsecase =
      GetAllProductsUsecase(productRepository);

  static final CreateProductUsecase createProductUsecase =
      CreateProductUsecase(productRepository);

  static final DeleteProductUsecase deleteProductUsecase =
      DeleteProductUsecase(productRepository);

  static final GetProductTransactionsUsecase getProductTransactionsUsecase =
      GetProductTransactionsUsecase(productRepository);

  static final RecordPurchaseUsecase recordPurchaseUsecase =
      RecordPurchaseUsecase(productRepository);

  static final RecordSaleUsecase recordSaleUsecase =
      RecordSaleUsecase(productRepository);

  static final RecordReturnUsecase recordReturnUsecase =
      RecordReturnUsecase(productRepository);
}
