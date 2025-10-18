import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class JobDatabaseHelper {
  static final JobDatabaseHelper instance = JobDatabaseHelper._init();
  static Database? _database;

  JobDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('job_ticket.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE jobs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            status TEXT,
            assignedTo TEXT,
            createdAt TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE urgent_tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            priority TEXT,
            dueDate TEXT,
            createdAt TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE urgent_tasks (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT,
              description TEXT,
              priority TEXT,
              dueDate TEXT,
              createdAt TEXT
            )
          ''');
        }
      },
    );
  }

  // Job CRUD
  Future<int> insertJob(Map<String, dynamic> job) async {
    final db = await instance.database;
    return await db.insert('jobs', job);
  }

  Future<List<Map<String, dynamic>>> getJobs() async {
    final db = await instance.database;
    return await db.query('jobs', orderBy: 'id DESC');
  }

  // Urgent Task CRUD
  Future<int> insertUrgentTask(Map<String, dynamic> task) async {
    final db = await instance.database;
    return await db.insert('urgent_tasks', task);
  }

  Future<List<Map<String, dynamic>>> getUrgentTasks() async {
    final db = await instance.database;
    return await db.query('urgent_tasks', orderBy: 'id DESC');
  }

  Future<int> deleteUrgentTask(int id) async {
    final db = await instance.database;
    return await db.delete('urgent_tasks', where: 'id = ?', whereArgs: [id]);
  }
}
