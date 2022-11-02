import 'dart:io';

import 'package:notes/models/task_models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBTask {
  static Database? _database;

  static final DBTask db = DBTask._();
  DBTask._();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDBTask();

    return _database;
  }

  Future<Database?> initDBTask() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'TaskDB.db');

    // Crear base de datos
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
         CREATE TABLE Task(
           id INTEGER PRIMARY KEY,
           completed INTEGER,
           task TEXT,
           details TEXT,
           repeat INTEGER,
           hoursSet TEXT,
           subtask TEXT

         )
        ''');
    });
  }

  Future<int> updateTask(TaskModel nuevoTask) async {
    final db = await database;
    final res = await db!.update('Task', nuevoTask.toJson(),
        where: 'id = ?', whereArgs: [nuevoTask.id]);
    return res;
  }

  Future<int> nuevoTask(TaskModel folderModel) async {
    final db = await database;

    final res = db!.insert('Task', folderModel.toJson());
    return res;
  }

  Future<List<TaskModel>> getTodosLostTask() async {
    final db = await database;
    final res = await db!.query('Task');

    return res.isNotEmpty ? res.map((s) => TaskModel.fromJson(s)).toList() : [];
  }

  Future<List<TaskModel>> getTaskporTipo(int completed) async {
    final db = await database;
    final res = await db!.rawQuery('''
      SELECT * FROM Task WHERE completed = '$completed'    
    ''');

    return res.isNotEmpty ? res.map((s) => TaskModel.fromJson(s)).toList() : [];
  }

  Future<int> deleTask(int id) async {
    final db = await database;
    final res = await db!.delete('Task', where: 'id = ?', whereArgs: [id]);
    return res;
  }
}
