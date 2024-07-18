import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:servises/data_models/db.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider{
  static final DBProvider db = DBProvider();
  Database? _database; 

  Future<Database> get database async{
    if(_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationCacheDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db){}, onCreate: (Database db, int version) async {
      await db.execute(
        """CREATE TABLE User (
          id INTEGER PRIMARY KEY
          title

        )"""
        );
    });
  }

  addUser(DBPhotoStudio user) async{
    final db = await database;
    var raw = await db.rawInsert(
      "INSERT Into User (id, )"
      "VaLUES (?,?,?)",
      [user.id],
    );
    return raw;
  }
}