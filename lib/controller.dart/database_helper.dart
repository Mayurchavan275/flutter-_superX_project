import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "client_db.db";
  static const _databaseVersion = 1;
  static const table = 'clients';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnSkill = 'skill';
  static const columnExperience = 'experience';
  static const columnImage = 'image';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnSkill TEXT NOT NULL,
        $columnExperience TEXT NOT NULL,
        $columnImage TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertClient(Map<String, dynamic> client) async {
    final db = await database;
    return await db.insert(table, client);
  }

  Future<List<Map<String, dynamic>>> getClients() async {
    final db = await database;
    return await db.query(table);
  }

  Future<int> deleteClient(int id) async {
    final db = await database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
