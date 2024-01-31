import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlData {
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
    String path = join(databasePath, "todo.db");
    Database myDb = await openDatabase(path, onCreate: (db, version) {
      db.execute('''
      CREATE TABLE "Todo"(
        'id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        'content' TEXT NOT NULL
      )
''');
    }, version: 1);
    return myDb;
  }

  readData(String sql) async {
    Database? myDb = await db;
    List<Map> response = await myDb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? myDb = await db;
    int response = await myDb!.rawInsert(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? myDb = await db;
    int response = await myDb!.rawDelete(sql);
    return response;
  }

  updateData(String sql) async {
    Database? myDb = await db;
    int response = await myDb!.rawUpdate(sql);
    return response;
  }

  deleteAlldatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, "todo.db");
    await deleteDatabase(path);
  }
}
