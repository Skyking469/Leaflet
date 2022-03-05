import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';
import '../models/note.dart';

class DatabaseHandler {
  Future<Database> initDB() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'Task.db');
    return openDatabase(dbPath, version: 1, onCreate: populateDb);
  }

  void populateDb(Database database, int version) async {
    await database.execute(
      "CREATE TABLE Task(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, date TEXT NOT NULL, location TEXT, isDone INTEGER);",
    );
    await database.execute(
        "CREATE TABLE Note(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, picture TEXT, body TEXT, audio TEXT);");
  }

  Future<int> createTask(Task task) async {
    final Database db = await initDB();
    var result = await db.insert("Task", task.toMap());
    return result;
  }

  Future<List<Task>> getTasks() async {
    final Database db = await initDB();
    var result = await db
        .query("Task", columns: ["id", "title", "date", "location", "isDone"]);
    return result.map((e) => Task.fromMap(e)).toList();
  }

  Future<Task?> getTask(int id) async {
    final Database db = await initDB();
    List<Map<String, dynamic>> results = await db.query("Task",
        columns: ["id", "title", "date", "location", "isDone"],
        where: 'id = ?',
        whereArgs: [id]);
    if (results.length > 0) {
      return new Task.fromMap(results.first);
    }
  }

  Future<int> updateTask(Task task) async {
    final Database db = await initDB();
    return await db
        .update("Task", task.toMap(), where: "id = ?", whereArgs: [task.id]);
  }

  Future<int> deleteTask(int id) async {
    final Database db = await initDB();
    return await db.delete("Task", where: 'id = ?', whereArgs: [id]);
  }

  Future<int> createNote(Note note) async {
    final Database db = await initDB();
    var result = await db.insert("Note", note.toMap());
    return result;
  }

  Future<List<Note>> getNotes() async {
    final Database db = await initDB();
    var result = await db
        .query("Note", columns: ["id", "title", "picture", "body", "audio"]);
    return result.map((e) => Note.fromMap(e)).toList();
  }

  Future<Note?> getNote(int id) async {
    final Database db = await initDB();
    List<Map<String, dynamic>> results = await db.query("Note",
        columns: ["id", "title", "picture", "body", "audio"],
        where: 'id = ?',
        whereArgs: [id]);
    if (results.length > 0) {
      return new Note.fromMap(results.first);
    }
  }

  Future<int> updateNote(Task note) async {
    final Database db = await initDB();
    return await db
        .update("Note", note.toMap(), where: "id = ?", whereArgs: [note.id]);
  }

  Future<int> deleteNote(int id) async {
    final Database db = await initDB();
    return await db.delete("Note", where: 'id = ?', whereArgs: [id]);
  }
}
