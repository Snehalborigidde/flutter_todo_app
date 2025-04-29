// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import '../models/todo_item.dart';
//
// class TodoDatabase {
//   static final TodoDatabase instance = TodoDatabase._init();
//   static Database? _database;
//
//
//   factory TodoDatabase() => instance;
//
//   TodoDatabase._init();
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//
//     _database = await _initDB('todos.db');
//     return _database!;
//   }
//
//   Future<Database> _initDB(String filePath) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);
//
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _createDB,
//     );
//   }
//
//   Future _createDB(Database db, int version) async {
//     const idType = 'INTEGER PRIMARY KEY';
//     const textType = 'TEXT NOT NULL';
//     const boolType = 'BOOLEAN NOT NULL';
//
//     await db.execute('''
//     CREATE TABLE todos (
//       id $idType,
//       title $textType,
//       isCompleted $boolType
//     )
//     ''');
//   }
//
//
//
//   Future<void> addTodo(TodoItem todo) async {
//     final db = await instance.database;
//     await  db.insert(
//   'todos',
//   todo.toMap(),
//   conflictAlgorithm: ConflictAlgorithm.replace,
// );
//   }
//
//   Future<List<TodoItem>> readAllTodos() async {
//     final db = await instance.database;
//     // final result = await db.query('todo');
//
//     // return result.map((json) => TodoItem.fromJson(json)).toList();
//
//     final List<Map<String, dynamic>> maps = await db.query('todos');
//
// // Convert the List<Map<String, dynamic>> into a List<TodoItem>.
// List<TodoItem> todos = List.generate(maps.length, (i) {
//   // return TodoItem.fromMap(maps[i]);
//   return TodoItem(
//     id: maps[i]['id'] as int,
//     title: maps[i]['title'] as String,
//     isCompleted: maps[i]['isCompleted'] != null ? maps[i]['isCompleted'] as bool : false,
//
//   );
// });
//
//    return todos;
//   }
//
// //  Future<List<TodoItem>> getTodos() async {
// //     final db = await database;
// //     return await db.query('todos');
// //   }
//
// //    Future<List<TodoItem>> readAllTodos() async {
// //     final db = await instance.database;
// //     // final result = await db.query('todo');
//
// //     // return result.map((json) => TodoItem.fromJson(json)).toList();
//
// //     final List<Map<String, dynamic>> maps = await db.query('todos');
//
// // // Convert the List<Map<String, dynamic>> into a List<TodoItem>.
// // List<TodoItem> todos = List.generate(maps.length, (i) {
// //   return TodoItem.fromMap(maps[i]);
// // });
//
// //      if (todos.isNotEmpty) {
// //       return todos;
// //     } else {
// //       return [];  // Return an empty list if no items are found
// //     }
// //   } catch (e) {
// //     // Handle the error, maybe logging or displaying it
// //     print('Error fetching items: $e');
// //     return [];  // Return an empty list or handle the error in another way
// //   }
//
// //   }
//
//
//
//   Future<void> updateTodoStatus(TodoItem todo) async {
//     final db = await instance.database;
//     await db.update('todo', todo.toJson(), where: 'id = ?', whereArgs: [todo.id]);
//   }
//
//   Future<void> deleteTodoById(int id) async {
//     final db = await instance.database;
//     await db.delete('todo', where: 'id = ?', whereArgs: [id]);
//   }
//
//   Future close() async {
//     final db = await instance.database;
//     db.close();
//   }
// }

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/todo_item.dart';

class TodoDatabase {
  static final TodoDatabase instance = TodoDatabase._init();
  static Database? _database;

  factory TodoDatabase() => instance;

  TodoDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('todos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        isCompleted INTEGER NOT NULL
      )
    ''');
  }

  Future<void> create(TodoItem todo) async {
    final db = await instance.database;
    await db.insert('todos', {
      'title': todo.title,
      'isCompleted': todo.isCompleted ? 1 : 0,
    });
  }

  // Future<List<TodoItem>> readAllTodos() async {
  //   final db = await instance.database;
  //   final result = await db.query('todos');
  //  debugPrint('db data ${result}');
  //   return result.map((json) => TodoItem.fromJson(json)).toList();
  // }

//   Future<List<TodoItem>> readAllTodos() async {
//     final db = await instance.database;
//     debugPrint('db => $db');
//     ; // final result = await db.query('todo');
//
//     // return result.map((json) => TodoItem.fromJson(json)).toList();
//
//     final List<Map<String, dynamic>> maps = await db.query('todos');
//     debugPrint('maps = ${maps}');
//     debugPrint('maps.length = ${maps.length}');
//     try{
//       if(maps.length != []) {
//       List<TodoItem> todos = List.generate(maps.length, (i) {
//         debugPrint('i=${i}');
//         // return TodoItem.fromMap(maps[i]);
//         debugPrint('maps[i][id] = ${maps[i]['id']}');
//         debugPrint('maps[i][title] = ${maps[i]['title']}');
//         debugPrint('maps[i][isCompleted] = ${maps[i]['isCompleted']}');
//         return TodoItem(
//           id: maps[i]['id'] as int,
//           title: maps[i]['title'] as String,
//           //isCompleted: maps[i]['isCompleted'] != null ? maps[i]['isCompleted'] as bool : false,
//           // Handle null for isCompleted
//           isCompleted: (maps[i]['isCompleted'] == false) ? false : true,
//         );
//       });
//       debugPrint('db data${todos}');
//       return todos;
//       } else {
//         return [];
//       }
//     }catch(e){
//       debugPrint('exception e = ${e}');
//       return [];
//     }
//
// // Convert the List<Map<String, dynamic>> into a List<TodoItem>.
//
//   }

  Future<List<TodoItem>> readAllTodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('todos');
    debugPrint('fetching data localyyyyyyyy = ${maps}');
    return List.generate(maps.length, (i) {
      return TodoItem(
        id: maps[i]['id'],
        title: maps[i]['title'],
        isCompleted: maps[i]['isCompleted'] == 1 ? true : false,
      );
    });

  }


  Future<void> addTodo(TodoItem todo) async {
    final db = await instance.database;
    await db.insert(
      'todos',
      //todo.toMap(),
      todo.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace, // To handle duplicate IDs
    );
  }



  Future<void> update(TodoItem todo) async {
    final db = await instance.database;
    await db.update(
      'todos',
      {
        'title': todo.title,
        'isCompleted': todo.isCompleted ? 0 : 1,
      },
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await instance.database;
    try{
      await db.delete(
        'todos',
        where: 'id = ?',
        whereArgs: [id],
      );
    }catch(e){
      debugPrint("Something went wrong when deleting an item: $e");
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  // Add the clearDatabase method here to remove all rows from the table
  Future<void> clearDatabase() async {
    final db = await instance.database;
    await db.delete('todos');  // Deletes all rows from the 'todos' table
  }

}
