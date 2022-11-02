import 'dart:io';

import 'package:notes/models/folder_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  static Database? _database;

  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  Future<Database?> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'ArchivesDB.db');

    // Crear base de datos
    return await openDatabase(path, version: 2,
        onCreate: (Database db, int version) async {
      await db.execute('''
         CREATE TABLE Archives(
           id INTEGER PRIMARY KEY,
           sub INTEGER,
           clase INTEGER,
           selected INTEGER,
           tipo INTEGER,
           titulo TEXT,
           nombre TEXT,
           imagen BLOB,
           cuerpo TEXT,
           fecha TEXT,
           updated TEXT,
           time TEXT


         )
        ''');
    });
  }

  Future<int> nuevoFolder(FolderModel folderModel) async {
    final db = await database;

    final res = db!.insert('Archives', folderModel.toJson());
    return res;
  }

  Future<List<FolderModel>> getTodosLosScans() async {
    final db = await database;
    final res = await db!.query('Archives');

    return res.isNotEmpty
        ? res.map((s) => FolderModel.fromJson(s)).toList()
        : [];
  }

  Future<List<FolderModel>> getScansPorTipo(int clase) async {
    final db = await database;
    final res = await db!.rawQuery('''
      SELECT * FROM Archives WHERE clase = '$clase'    
    ''');

    return res.isNotEmpty
        ? res.map((s) => FolderModel.fromJson(s)).toList()
        : [];
  }

  Future<int> updateScan(FolderModel nuevoScan) async {
    final db = await database;
    final res = await db!.update('Archives', nuevoScan.toJson(),
        where: 'id = ?', whereArgs: [nuevoScan.id]);
    return res;
  }

  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db!.delete('Archives', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAllScans() async {
    final db = await database;
    final res = await db!.rawDelete('''
      DELETE FROM Archives    
    ''');
    return res;
  }
}
