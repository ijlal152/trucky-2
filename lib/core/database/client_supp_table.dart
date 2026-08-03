import 'package:trucky/core/database/table_names.dart';

/// Column scheme for the `client_supp_table`.
///
/// Mirrors the fields of the legacy Hive model
/// (`ClientSuppHiveModel`) so DAOs and repositories can reference columns
/// without stringly-typed SQL.
abstract final class ClientSuppTable {
  static const String name = TableNames.clientSuppTable;

  static const String id = 'id';
  static const String userId = 'user_id';
  static const String entityName = 'name';
  static const String role = 'role';
  static const String phoneNumber = 'phone_number';
  static const String gpsLocation = 'gps_location';
  static const String isSynced = 'is_synced';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}
