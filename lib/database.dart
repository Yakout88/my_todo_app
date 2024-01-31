
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseConfig {
  static Database? _db;
  get db async {
    if (_db == null) {
      _db = await openDb();
      return _db;
    } else {
      return _db;
    }
  }

  openDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, "sql_todo.db");
    Database myDb = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(''' 
        CREATE TABLE notes(
          'id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          'content' TEXT NOT NULL  
        )
        ''');
      },
    );
    return myDb;
  }
}
