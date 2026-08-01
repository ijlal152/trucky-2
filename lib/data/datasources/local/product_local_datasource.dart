import 'package:sqflite/sqflite.dart';
import 'package:trucky/domain/entities/product_entity.dart';

abstract class ProductLocalDatasource {
  Future<int> insertProduct(ProductModel product);
  Future<int> updateProduct(ProductModel product);
  Future<int> softDeleteProduct(int id);

  Future<ProductModel?> getProductById(int id);
  Future<List<ProductModel>> getAllProducts();

  Future<List<ProductModel>> getUnsyncedProducts();
}

abstract class DBHelper {
  Future<Database> get database;
}

class ProductLocalDatasourceImpl implements ProductLocalDatasource {
  final DBHelper dbHelper;

  ProductLocalDatasourceImpl(this.dbHelper);

  static const String tableName = 'products';

  /// INSERT PRODUCT
  @override
  Future<int> insertProduct(ProductModel product) async {
    final db = await dbHelper.database;

    final now = DateTime.now();

    final productMap = product.toMap()
      ..addAll({
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
        'is_synced': 0,
      });

    return await db.insert(
      tableName,
      productMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// UPDATE PRODUCT
  @override
  Future<int> updateProduct(ProductModel product) async {
    final db = await dbHelper.database;

    final updatedMap = product.toMap()
      ..addAll({
        'updated_at': DateTime.now().toIso8601String(),
        'is_synced': 0, // mark for sync
      });

    return await db.update(
      tableName,
      updatedMap,
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  /// SOFT DELETE (IMPORTANT for sync)
  @override
  Future<int> softDeleteProduct(int id) async {
    final db = await dbHelper.database;

    return await db.update(
      tableName,
      {
        'is_deleted': 1,
        'is_synced': 0,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// GET PRODUCT BY ID
  @override
  Future<ProductModel?> getProductById(int id) async {
    final db = await dbHelper.database;

    final result = await db.query(
      tableName,
      where: 'id = ? AND is_deleted = 0',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return ProductModel.fromMap(result.first);
    }
    return null;
  }

  /// GET ALL PRODUCTS (ACTIVE ONLY)
  @override
  Future<List<ProductModel>> getAllProducts() async {
    final db = await dbHelper.database;

    final result = await db.query(
      tableName,
      where: 'is_deleted = 0',
      orderBy: 'created_at DESC',
    );

    return result.map((e) => ProductModel.fromMap(e)).toList();
  }

  /// GET UNSYNCED PRODUCTS (for future API sync)
  @override
  Future<List<ProductModel>> getUnsyncedProducts() async {
    final db = await dbHelper.database;

    final result = await db.query(tableName, where: 'is_synced = 0');

    return result.map((e) => ProductModel.fromMap(e)).toList();
  }
}
