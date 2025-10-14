import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseServices {
  static Database? _db;
  static final DatabaseServices instance = DatabaseServices._constructor();

  final String _tableName = "history";
  final String _colId = "id";
  final String _colSubject = "subject";
  final String _colPrompt = "prompt";
  final String _colShortAnswer = "shortAnswer";
  final String _colDetailedAnswer = "detailedAnswer";
  final String _colImagePath = "imagePath";
  final String _colDate = "date";

  DatabaseServices._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'ai_solver_history.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            $_colId INTEGER PRIMARY KEY AUTOINCREMENT,
            $_colSubject TEXT,
            $_colPrompt TEXT,
            $_colShortAnswer TEXT,
            $_colDetailedAnswer TEXT,
            $_colImagePath TEXT,
            $_colDate TEXT
          )
        ''');
      },
    );
  }

  // ✅ Insert new history record
  Future<int> insertHistory({
    required String subject,
    required String prompt,
    required String shortAnswer,
    required String detailedAnswer,
    required String imagePath,
  }) async {
    final db = await database;
    return await db.insert(_tableName, {
      _colSubject: subject,
      _colPrompt: prompt,
      _colShortAnswer: shortAnswer,
      _colDetailedAnswer: detailedAnswer,
      _colImagePath: imagePath,
      _colDate: DateTime.now().toIso8601String(),
    });
  }

  //  Get all history
  Future<List<Map<String, dynamic>>> getAllHistory() async {
    final db = await instance.database;
    final result = await db.query(_tableName, orderBy: "$_colId DESC");
    print(" Fetched History Rows: ${result.length}");
    return result;
  }

  //  Get history by ID
  Future<Map<String, dynamic>?> getHistoryById(int id) async {
    final db = await database;
    final res = await db.query(_tableName, where: '$_colId = ?', whereArgs: [id]);
    if (res.isNotEmpty) return res.first;
    return null;
  }

  //  Delete record by ID
  Future<void> deleteHistory(int id) async {
    final db = await instance.database;
    await db.delete(_tableName, where: '$_colId = ?', whereArgs: [id]);
  }

  //  Clear all history
  Future<void> clearAllHistory() async {
    final db = await instance.database;
    await db.delete(_tableName);
  }
}
