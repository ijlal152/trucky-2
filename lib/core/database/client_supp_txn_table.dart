import 'package:trucky/core/database/table_names.dart';

/// Column scheme for the `client_supp_transactions_table`.
///
/// Mirrors the fields of the legacy Hive model (`ClientSuppTxnsHiveModel`) so
/// DAOs and repositories can reference columns without stringly-typed SQL.
abstract final class ClientSuppTxnTable {
  static const String name = TableNames.clientSuppTransactionsTable;

  static const String id = 'id';
  static const String userId = 'user_id';
  static const String clientSuppId = 'client_supp_id';
  static const String transactionId = 'transaction_id';
  static const String clientSupplierName = 'client_supplier_name';
  static const String role = 'role';
  static const String txnData = 'txn_data';
  static const String discountAmount = 'discount_amount';
  static const String amount = 'amount';
  static const String paymentType = 'payment_type';
  static const String note = 'note';
  static const String isSynced = 'is_synced';
}