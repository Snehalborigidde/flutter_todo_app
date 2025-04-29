import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import '../database/todo_database.dart';
import '../models/failure.dart';
import '../models/todo_item.dart';

class TodoService {
  Dio dio = Dio();

  final String baseUrl = 'https://jsonplaceholder.typicode.com/todos';
   TodoDatabase database = TodoDatabase();

  // Constructor with dependency injection
  TodoService({Dio? dio, TodoDatabase? database,})
      : dio = dio ?? Dio(),
        database = database ?? TodoDatabase();

// Fetch todos from both local and remote sources
//   Future<List<TodoItem>> fetchTodos() async {
//     List<TodoItem> localTodos = [];
//     List<TodoItem> remoteTodos = [];
//
//     try {
//       // Fetching from remote API
//       Response response = await dio.get(baseUrl);
//       remoteTodos = (response.data as List).map((json) => TodoItem.fromJson(json)).toList();
//     } catch (e) {
//       print('Error fetching remote data: $e');
//     }
//
//     try {
//       // Fetching from local database
//       localTodos = await database.readAllTodos();
//     } catch (e) {
//       print('Error fetching local data: $e');
//     }
//
//     // Combine both local and remote todos
//     final combinedTodos = [...remoteTodos, ...localTodos];
//
//     return combinedTodos;
//   }


  // Future<List<TodoItem>> fetchTodos() async {
  //   // Fetch local data
  //   List<TodoItem> localTodos = await database.readAllTodos();
  //
  //   // Fetch remote data
  //   try {
  //     Response response = await dio.get(baseUrl);
  //     List<TodoItem> remoteTodos = (response.data as List)
  //         .map((json) => TodoItem.fromJson(json))
  //         .toList();
  //
  //     // Save remote todos to local database
  //     for (var todo in remoteTodos) {
  //       await database.addTodo(todo);
  //     }
  //
  //     // Return merged data
  //     return [...localTodos, ...remoteTodos];
  //   } catch (e) {
  //     print("Error fetching remote data: $e");
  //     // If remote fetching fails, return local data
  //     return localTodos;
  //   }
  // }

  // Future<Object> fetchTodos() async {
  //   // Fetch local data
  //   List<TodoItem> localTodos = await database.readAllTodos();
  //
  //   try {
  //     // Fetch remote data
  //     Response response = await dio.get(baseUrl);
  //     print("API Response Data: ${response.data}");
  //     List<TodoItem> remoteTodos = (response.data as List)
  //         .map((json) => TodoItem.fromJson(json))
  //         .toList();
  //
  //     // Save unique remote todos to the local database
  //     for (var todo in remoteTodos) {
  //       bool existsLocally = localTodos.any((localTodo) => localTodo.id == todo.id);
  //       if (!existsLocally) {
  //         await database.addTodo(todo);
  //       }
  //     }
  //
  //     // Return merged data
  //     return [...localTodos, ...remoteTodos];
  //
  //   } catch (e) {
  //     print("Error fetching remote data: $e");
  //     // Return local data if remote fetch fails
  //     return localTodos;
  //   }
  // }

//fetching remote data
  // Fetch Todos with Either for error handling
  Future<Either<Failure, List<TodoItem>>> fetchTodos() async {
    try {
      // Fetch only remote data for testing
      Response response = await dio.get(baseUrl);

      // Convert response data to List<TodoItem>
      List<TodoItem> remoteTodos = (response.data as List)
          .map((json) => TodoItem.fromJson(json))
          .toList();
      print("Fetched remote todos: $remoteTodos");

      // Debug point: Print before starting to save to the database
      print("Attempting to save to local database");

      // Save each todo to the SQLite database
      for (var todo in remoteTodos) {
        await database.addTodo(todo);
      }
      print("remote data saved to local database");
      return Right(remoteTodos);

    } catch (e, stacktrace) {
      print("Error fetching remote data: $e");
      print("Stack trace: $stacktrace");
      return Left(Failure("Failed to fetch todos from remote source"));
    }
  }



  // Insert Todo remotely
  Future<void> addTodoRemote(TodoItem todo) async {
    await dio.post(baseUrl, data: todo.toJson());
  }


  Future<void> toggleTodoRemote(TodoItem todo) async {
    final url = '$baseUrl/${todo.id}';
    await dio.put(url, data: todo.toJson());
  }

  Future<void> deleteTodoRemote(int id) async {
    final url = '$baseUrl/$id';
    await dio.delete(url);
  }
}
