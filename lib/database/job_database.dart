import 'package:manager_side/models/job_ticketmodel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class JobDatabase {
  static final JobDatabase instance = JobDatabase._init();
  static Database? _database;

  JobDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('jobticket.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // ✅ Increment version to apply ALTER TABLE when upgrading
      onCreate: (db, version) async {
        await db.execute('''
    CREATE TABLE jobs (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT,
      status TEXT,
      assignedTo TEXT,
      createdAt TEXT,
      priority TEXT
    )
  ''');

        // ✅ Separate table for urgent tasks
        await db.execute('''
    CREATE TABLE urgent_jobs (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT,
      status TEXT,
      assignedTo TEXT,
      createdAt TEXT,
      priority TEXT
    )
  ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // ✅ Add priority column if upgrading from older version
        if (oldVersion < 2) {
          await db.execute(
            "ALTER TABLE jobs ADD COLUMN priority TEXT DEFAULT 'Low'",
          );
        }
      },
    );
  }

  Future<Job> insertJob(Job job) async {
    final db = await instance.database;
    final id = await db.insert(
      'jobs',
      job.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return job.copyWith(id: id);
  }

  // ✅ Get all jobs sorted by priority (High → Medium → Low) and then by ID DESC
  Future<List<Job>> getAllJobs() async {
    final db = await instance.database;

    // Custom SQL CASE to sort by priority order
    final result = await db.query(
      'jobs',
      orderBy: '''
        CASE 
          WHEN priority = 'High' THEN 1
          WHEN priority = 'Medium' THEN 2
          WHEN priority = 'Low' THEN 3
          ELSE 4
        END, 
        id DESC
      ''',
    );

    return result.map((e) => Job.fromMap(e)).toList();
  }

  Future<int> updateJob(Job job) async {
    final db = await instance.database;
    return db.update('jobs', job.toMap(), where: 'id = ?', whereArgs: [job.id]);
  }

  Future<int> deleteJob(int id) async {
    final db = await instance.database;
    return db.delete('jobs', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
