import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'note.dart';

class DatabaseService {
  static Database _database;
  final String table = 'notes';

  Future<Database> get db async {
    if (_database != null) return _database;
    _database = await initDatabase();

    return _database;
  }

  initDatabase() async {
    var dir = await getDatabasesPath();
    String path = join(dir, 'notes.db');
    var database = await openDatabase(path, version: 1,
        onCreate: (Database _db, int version) async {
      await _db.execute(
          'CREATE TABLE $table(id INTEGER PRIMARY KEY AUTOINCREMENT, date INTEGER, title TEXT, content TEXT)');
    });

    return database;
  }

  Future<List<Note>> getNotes() async {
    var database = await db;
    List<Map<String, dynamic>> maps =
        await database.rawQuery('SELECT * FROM $table ORDER BY date DESC');
    List<Note> notes = new List<Note>();
    for (Map<String, dynamic> map in maps) {
      notes.add(Note.fromMap(map));
    }

    return notes;
  }

  Future<void> delete(Note note) async {
    var database = await db;
    await database.delete(table, where: 'id = ?', whereArgs: [note.id]);
  }

  Future<void> add(Note note) async {
    var database = await db;
    await database.insert(table, note.toMap());
  }

  Future<void> update(Note note) async {
    var database = await db;
    await database
        .update(table, note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }
}
