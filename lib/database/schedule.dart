import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TodoDatabase {
  Future<Database> createDB() async {
    Database db = await openDatabase(
      join(await getDatabasesPath(), "TodoDB.db"),
      version: 1,
      onCreate: (db, version) {
        db.execute('''
           create table Todo(
           id Integer primary key autoincrement,
           title TEXT,
           description TEXT,
           date TEXT
           )
          ''');
      },
  //      onUpgrade: (db, oldVersion, newVersion) async {
  //   if (oldVersion < 2) {
  //     // ✅ add missing column
  //     await db.execute("ALTER TABLE Todo ADD COLUMN description TEXT");
  //   }
  // },
    );
    return db;
  }

  Future<List<Map>> getTodoItems() async {
    Database localDb = await createDB();
    List<Map<String, dynamic>> list = await localDb.query("Todo");
    return list;
  }

  //Add Data
  void insertTodoItem(Map<String, dynamic> obj) async {
    Database localdb = await createDB();
    await localdb.insert(
      "Todo",
      obj,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTodoItem(Map<String, dynamic> obj) async {
    Database localDb = await createDB();
    await localDb.update("Todo",obj, where: "id=?",whereArgs: [obj['id']]);
  }

  Future<void> deleteTodoItem(int index) async {
    Database localDb = await createDB();
    await localDb.delete("Todo", where: "id=?",whereArgs: [index]);
  }
}
