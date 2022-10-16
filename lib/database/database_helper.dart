import 'dart:async';
import 'dart:io';
import 'package:crud/model/todo_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? _database;

  Future<Database?> get db async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "todo.db");
    var opendatabase = openDatabase(path, version: 1, onCreate: _onCreate);
    return opendatabase;
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE todo 
    (  
    id INTEGER PRIMARY KEY,
    title TEXT,
    description TEXT,
    dateTime TEXT
    
    )
   
    ''');
  }

  Future addTodo(TodoModel todoModel) async {
    Database? database = await db;
    return await database!.insert('todo', todoModel.toJson());
  }

  Future<List<TodoModel>?> getTodoModel() async {
    Database? database = await db;
    var data = await database!.query("todo", orderBy: "id");

    List<TodoModel> todoModels =
        data.map((e) => TodoModel.fromJson(e)).toList();
    return todoModels;
  }
}
