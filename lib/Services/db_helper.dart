import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../Models/local_message_model.dart';

class DatabaseHelper {
  static const dbName = "database.db";
  static const dbVersion = 1;
  static const dbTable = "myTable";
  static const columnId = 'id';
  static const columnName = 'name';



  static final DatabaseHelper instance = DatabaseHelper();

  static Database? _database;

  Future<Database?> get database async {
   _database ??= await initDB();
   return _database;
  }
  initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path,dbName);
    return await openDatabase(path,version: dbVersion,onCreate: onCreate);
  }
  Future onCreate(Database db,int version) async {
    db.execute('''
    CREATE TABLE $dbTable(
    $columnId INTEGER PRIMARY KEY,
    $columnName TEXT NOT NULL
    )
    ''');
  }

  insertDb(MessageModel message) async {
    // var data = List.generate(message.data!.getAllMessage!.items!.length, (index) => message.data!.getAllMessage!);
    final Database db = await initDB();
    final id = await db.insert(
        'myTable',
      message.toMap()
      ,);
  }
  Future<List<MessageModel>> getItems() async {
    final db = await DatabaseHelper.instance.initDB();
    final List<Map<String, Object?>> queryResult =
    await db.query('myTable');
    return queryResult.map((e) => MessageModel.fromMap(e)).toList();
  }

  // insertDb(Map<String,dynamic> row) async {
  //   Database? db = await instance.database;
  //   return await db!.insert(dbTable, row);
  // }
  Future<List<Map<String,dynamic>>> queryDb() async {
    Database? db = await instance.database;
    return await db!.query(dbTable);
  }
}