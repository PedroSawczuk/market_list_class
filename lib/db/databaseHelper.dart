import 'package:market_list_project/models/itemModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, 'market_list_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''CREATE TABLE items(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      quantity INTEGER,
      status TEXT
    )''');
  }

  Future<int> insertItem(ItemModel item) async {
    final db = await instance.database;
    return await db.insert('items', item.toMap());
  }

  Future<List<ItemModel>> getItems({String? status}) async {
    final db = await instance.database;
    final result = await db.query(
      'items',
      where: status != null ? 'status = ?' : null,
      whereArgs: status != null ? [status] : null,
    );
    return result.map((json) => ItemModel.fromMap(json)).toList();
  }

  Future<void> deleteItem(int id) async {
    final db = await instance.database;
    await db.delete(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateItemStatus(int id, String status) async {
    final db = await instance.database;
    await db.update(
      'items',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
