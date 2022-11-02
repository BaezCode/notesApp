import 'dart:io';

import 'package:notes/models/pdfs_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBPdfs {
  static Database? _database;

  static final DBPdfs db = DBPdfs._();
  DBPdfs._();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  Future<Database?> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'PdfsDB.db');

    // Crear base de datos
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
         CREATE TABLE Pdfs(
           id INTEGER PRIMARY KEY,
           nombre TEXT,
           fecha TEXT,
           path TEXT
         )
        ''');
    });
  }

  Future<int> nuevoPdfs(PdfsModel folderModel) async {
    final db = await database;

    final res = db!.insert('Pdfs', folderModel.toJson());
    return res;
  }

  Future<List<PdfsModel>> getTodosLosPdfs() async {
    final db = await database;
    final res = await db!.query('Pdfs');

    return res.isNotEmpty ? res.map((s) => PdfsModel.fromJson(s)).toList() : [];
  }

  Future<int> deletePfs(int id) async {
    final db = await database;
    final res = await db!.delete('Pdfs', where: 'id = ?', whereArgs: [id]);
    return res;
  }
}
