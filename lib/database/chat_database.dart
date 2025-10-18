import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ChatDatabaseHelper {
  static final ChatDatabaseHelper instance = ChatDatabaseHelper._init();
  static Database? _database;

  ChatDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('chat_manager.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE messages (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            clientId TEXT,
            sender TEXT,
            message TEXT,
            timestamp TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertMessage(Map<String, dynamic> message) async {
    final db = await instance.database;
    return await db.insert('messages', message);
  }

  Future<List<Map<String, dynamic>>> getMessages(String clientId) async {
    final db = await instance.database;
    return await db.query(
      'messages',
      where: 'clientId = ?',
      whereArgs: [clientId],
      orderBy: 'id ASC',
    );
  }

  Future<int> updateMessage(int id, String newMessage) async {
    final db = await instance.database;
    return await db.update(
      'messages',
      {'message': newMessage},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteMessage(int id) async {
    final db = await instance.database;
    return await db.delete(
      'messages',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
