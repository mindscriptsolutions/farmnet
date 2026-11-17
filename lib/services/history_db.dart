import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/diagnosis_record.dart';

/// Local SQLite store for diagnosis history. Fully offline and persistent.
class HistoryDb {
  static final HistoryDb instance = HistoryDb._();
  HistoryDb._();

  Database? _db;

  Future<Database> get _database async {
    if (_db != null) return _db!;
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'farmnet_history.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE diagnoses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            imagePath TEXT NOT NULL,
            crop TEXT NOT NULL,
            disease TEXT NOT NULL,
            status TEXT NOT NULL,
            confidence REAL NOT NULL,
            symptoms TEXT NOT NULL,
            prevention TEXT NOT NULL,
            management TEXT NOT NULL,
            timestamp INTEGER NOT NULL
          )
        ''');
      },
    );
    return _db!;
  }

  Future<int> insert(DiagnosisRecord r) async {
    final db = await _database;
    final map = r.toMap()..remove('id');
    return db.insert('diagnoses', map);
  }

  Future<List<DiagnosisRecord>> getAll() async {
    final db = await _database;
    final rows = await db.query('diagnoses', orderBy: 'timestamp DESC');
    return rows.map((e) => DiagnosisRecord.fromMap(e)).toList();
  }

  Future<void> delete(int id) async {
    final db = await _database;
    await db.delete('diagnoses', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clear() async {
    final db = await _database;
    await db.delete('diagnoses');
  }
}
