import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wms/models/product_offline_model.dart';

class DatabaseHandler {
  static final _dbName = 'dbUbon2.db';
  static final _dbVersion = 1;
  // ! TABLE
  static final tbName = "product";
  // ! COLUMN
  static String id = "id";
  static String location = "location";
  static String productcode = "productcode";
  static String count = "count";
  // ignore: non_constant_identifier_names
  static String create_current = "create_current";
  static String productname = "productname";

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    print(join(path, _dbName));
    return openDatabase(
      join(path, _dbName),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE $tbName($id INTEGER PRIMARY KEY AUTOINCREMENT, $location TEXT NOT NULL,$productcode TEXT NOT NULL, $count TEXT NOT NULL,$productname TEXT,$create_current TEXT NOT NULL)",
        );
      },
      version: _dbVersion,
    );
  }

  Future<int> insertProduct(List<ProductLocal> product) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var user in product) {
      // print(user.toJson());
      result = await db.insert('$tbName', user.toJson());
    }
    return result;
  }

  Future<List<ProductLocal>> retrieveUsers() async {
    List<ProductLocal> list = [];
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('$tbName');
    list = queryResult.map((e) => ProductLocal.fromJson(e)).toList();
    print(list.length);
    return list;
  }

  Future<void> deleteUser(int id) async {
    final db = await initializeDB();
    await db.delete(
      '$tbName',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
