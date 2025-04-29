import 'package:sqflite/sqflite.dart';
import '../models/todo_item.dart';

// class TodoRepository {
//   final Database database;

//   TodoRepository({required this.database});

//   Future<List<TodoItem>> getTodos() async {
//     final List<Map<String, dynamic>> maps = await database.query('todos');
//     return List.generate(maps.length, (i) {
//       return TodoItem(
//         id: maps[i]['id'],
//         title: maps[i]['title'],
//         isCompleted: maps[i]['isCompleted'] == 1 ? true : false,
//       );
//     });
//   }

  // Future<void> addTodo(TodoItem todo) async {
  //   await database.insert(
  //     'todos',
  //     todo.toJson(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

//   Future<void> removeTodo(String id) async {
//     await database.delete(
//       'todos',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }

//   Future<void> toggleTodoCompletion(String id) async {
//     final todo = await database.query('todos', where: 'id = ?', whereArgs: [id]);
//     if (todo.isNotEmpty) {
//       final isCompleted = todo.first['isCompleted'] == 1 ? 0 : 1;
//       await database.update(
//         'todos',
//         {'isCompleted': isCompleted},
//         where: 'id = ?',
//         whereArgs: [id],
//       );
//     }
//   }
// }
