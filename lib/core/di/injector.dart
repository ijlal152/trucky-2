import 'package:trucky/core/network/api_client.dart';
import 'package:trucky/core/network/mock_api_client.dart';
import 'package:trucky/core/network/network_info.dart';
import 'package:trucky/data/datasources/local/client_supp_local_data_source.dart';
import 'package:trucky/data/datasources/local/product_local_data_source.dart';
import 'package:trucky/data/repositories/client_supp_repository_impl.dart';
import 'package:trucky/data/repositories/product_repository_impl.dart';
import 'package:trucky/domain/repositories/client_supp_repository.dart';
import 'package:trucky/domain/repositories/product_repository.dart';
import 'package:trucky/domain/usecases/add_client_supp_txn_usecase.dart';
import 'package:trucky/domain/usecases/add_client_supp_usecase.dart';
import 'package:trucky/domain/usecases/create_product_usecase.dart';
import 'package:trucky/domain/usecases/delete_client_supp_txn_usecase.dart';
import 'package:trucky/domain/usecases/delete_client_supp_usecase.dart';
import 'package:trucky/domain/usecases/delete_product_usecase.dart';
import 'package:trucky/domain/usecases/delete_transactions_by_transaction_id_usecase.dart';
import 'package:trucky/domain/usecases/fetch_all_client_supp_txn_usecase.dart';
import 'package:trucky/domain/usecases/fetch_all_client_supp_usecase.dart';
import 'package:trucky/domain/usecases/fetch_all_product_transactions_usecase.dart';
import 'package:trucky/domain/usecases/get_all_products_usecase.dart';
import 'package:trucky/domain/usecases/get_product_transactions_usecase.dart';
import 'package:trucky/domain/usecases/record_purchase_usecase.dart';
import 'package:trucky/domain/usecases/record_return_usecase.dart';
import 'package:trucky/domain/usecases/record_sale_usecase.dart';
import 'package:trucky/domain/usecases/rebuild_snapshots_for_products_usecase.dart';
import 'package:trucky/domain/usecases/update_client_supp_usecase.dart';

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

  static final CreateProductUsecase createProductUsecase = CreateProductUsecase(
    productRepository,
  );

  static final DeleteProductUsecase deleteProductUsecase = DeleteProductUsecase(
    productRepository,
  );

  static final GetProductTransactionsUsecase getProductTransactionsUsecase =
      GetProductTransactionsUsecase(productRepository);

  static final FetchAllProductTransactionsUsecase
      fetchAllProductTransactionsUsecase = FetchAllProductTransactionsUsecase(
    productRepository,
  );

  static final RecordPurchaseUsecase recordPurchaseUsecase =
      RecordPurchaseUsecase(productRepository);

  static final RecordSaleUsecase recordSaleUsecase = RecordSaleUsecase(
    productRepository,
  );

  static final RecordReturnUsecase recordReturnUsecase = RecordReturnUsecase(
    productRepository,
  );

  static final DeleteTransactionsByTransactionIdUsecase
      deleteTransactionsByTransactionIdUsecase =
      DeleteTransactionsByTransactionIdUsecase(productRepository);

  static final RebuildSnapshotsForProductsUsecase
      rebuildSnapshotsForProductsUsecase =
      RebuildSnapshotsForProductsUsecase(productRepository);

  // ---------------- Client / Supplier module ----------------

  static final ClientSuppLocalDataSource clientSuppLocalDataSource =
      ClientSuppLocalDataSource();

  static final ClientSuppRepository clientSuppRepository =
      ClientSuppRepositoryImpl(local: clientSuppLocalDataSource);

  // ---------------- Client / Supplier use cases ----------------

  static final FetchAllClientSuppUsecase fetchAllClientSuppUsecase =
      FetchAllClientSuppUsecase(clientSuppRepository);

  static final FetchAllClientSuppTxnUsecase fetchAllClientSuppTxnUsecase =
      FetchAllClientSuppTxnUsecase(clientSuppRepository);

  static final AddClientSuppUsecase addClientSuppUsecase = AddClientSuppUsecase(
    clientSuppRepository,
  );

  static final UpdateClientSuppUsecase updateClientSuppUsecase =
      UpdateClientSuppUsecase(clientSuppRepository);

  static final DeleteClientSuppUsecase deleteClientSuppUsecase =
      DeleteClientSuppUsecase(clientSuppRepository);

  static final AddClientSuppTxnUsecase addClientSuppTxnUsecase =
      AddClientSuppTxnUsecase(clientSuppRepository);

  static final DeleteClientSuppTxnUsecase deleteClientSuppTxnUsecase =
      DeleteClientSuppTxnUsecase(clientSuppRepository);
}
