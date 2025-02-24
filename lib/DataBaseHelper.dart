// database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todolist/main.dart';

class DatabaseHelper {
  static final _databaseName = 'todo_list.db';
  static final _databaseVersion = 1;

  static final table = 'todo_items';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        completed INTEGER NOT NULL,
        dueDate TEXT NOT NULL
      );
    ''');
  }

  Future<int> insert(ToDoItem item) async {
    final db = await database;
    return await db.insert(table, item.toMap());
  }

  Future<List<ToDoItem>> getAllItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return ToDoItem(
        id: maps[i]['id'],
        title: maps[i]['title'],
        completed: maps[i]['completed'] == 1,
        dueDate: DateTime.parse(maps[i]['dueDate']),
      );
    });
  }

  Future<int> update(ToDoItem item) async {
    final db = await database;
    return await db.update(table, item.toMap(), where: 'id = ?', whereArgs: [item.id]);
  }

  Future<int> delete(ToDoItem item) async {
    final db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [item.id]);
  }
}