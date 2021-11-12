//@dart=2.9
import 'Events.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'eventDTO.dart';

class DataBaseHelper {
  static Database _database;
  DataBaseHelper._();
  static DataBaseHelper _databaseHelper;
  factory DataBaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DataBaseHelper._();
      return _databaseHelper;
    } else {
      return _databaseHelper;
    }
  }
  Future<Database> get _getDatabase async{
    if(_database != null){
      return _database;
    }
    _database = await _initializeDataBase();
    return _database;
  }
  Future<Database> _initializeDataBase() async{
    return await openDatabase(join(await getDatabasesPath(), 'calendarDatabases.db'),
        onCreate: (db,version) async{
          await db.execute('''
      CREATE TABLE taskstable (id INTEGER PRIMARY KEY AUTOINCREMENT, eventName Text, eventDescription Text, dateTime Text, todateTime Text)
      ''');
        },
        version: 1
    );

  }
  Future<List<Map<String, dynamic>>> getTasks() async {
    var db = await _getDatabase;
    var result = await db.query("taskstable", orderBy: "time ASC");
    return result;
  }

  Future<List<Events>> getTaskList() async {
    var taskMapList = await getTasks();
    var taskList = List<Events>();
    for (Map map in taskMapList) {
      taskList.add(Events.fromMap(map));
    }
    return taskList;
  }

  Future<int> insertEvents(Events eventModel) async {
    EventDTO eventDTO = EventDTO();
    eventDTO.eventName = eventModel.eventName;
    eventDTO.eventDescription = eventModel.eventDescription;
    eventDTO.dateTime = eventModel.dateTime.toString();
    eventDTO.todateTime = eventModel.todateTime.toString();

    var db = await _getDatabase;
    var result = await db.insert("taskstable", eventDTO.toMap());

    print(eventDTO.dateTime.toString());
    return result;
  }

  Future<int> updateTask(Events eventModel) async {
    EventDTO eventDTO = EventDTO();
    eventDTO.id = eventModel.id;
    eventDTO.eventName = eventModel.eventName;
    eventDTO.eventDescription = eventModel.eventDescription;
    eventDTO.dateTime = eventModel.dateTime.toString();
    eventDTO.todateTime =eventModel.todateTime.toString();
    var db = await _getDatabase;
    var result = await db.update("taskstable", eventDTO.toMap(),
        where: 'id = ?', whereArgs: [eventModel.id]);
    return result;
  }

  Future<int> deleteTask(int id) async {
    var db = await _getDatabase;
    var result = await db.delete("taskstable", where: 'id = ?', whereArgs: [id]);
    return result;
  }
  Future<List<Events>> retrieveEvents(String date) async {
    final Database db = await _initializeDataBase();
    final List<Map<String, Object>> queryResult =
    await db.rawQuery('select * from taskstable where dateTime=?', [date]);
    return queryResult.map((e) => Events.fromMap(e)).toList();
  }

  Future<List<Events>> retrieveAllData() async {
    final Database db = await _initializeDataBase();
    final List<Map<String, Object>> queryResult = await db.query('taskstable');
    return queryResult.map((e) => Events.fromMap(e)).toList();
  }
}