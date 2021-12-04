//@dart=2.9
import 'package:formspage/models/Event.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DataBaseHelper {
  static Database _database;
  final String table = 'dairydetail';
  final int version = 1;

  Future<Database> get database async{
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async{
    var dir = await getDatabasesPath();
    String path = join(dir,'DairyTable.db');
    var database = await openDatabase(path,version: version, onCreate: (Database db, int version){
      db.execute('CREATE TABLE $table(id INTEGER PRIMARY KEY AUTOINCREMENT, uuid TEXT,Description TEXT ,style TEXT,images TEXT,Background TEXT,createdAt INT,eventdate INT,Color INTEGER,shared INTEGER,sync INTEGER)');
    });
    return database;
  }

  Future<void> Insert(Events event)async{
    Database db = await database;
    await db.insert(table, event.toMap());
  }

  Future<void> update(Events event)async{
    Database db = await database;
    await db.update(table, event.toMap(),where: 'id = ? ',whereArgs: [event.id]);
  }

  Future<void> delete(Events event)async{
    Database db = await database;
    await db.delete(table, where: 'id = ? ', whereArgs: [event.id]);
  }

  Future<List<Events>> getList() async{
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(table);
    List<Events> dairyList = [];
    for(var map in maps){
      dairyList.add(Events.fromMap(map));
    }
    return dairyList;
  }
}