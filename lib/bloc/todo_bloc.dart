

// // w/o dio
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_todo/database/todo_database.dart';
// import 'package:flutter_todo/services/todo_service.dart';
// import 'todo_event.dart';
// import 'todo_state.dart';
// import '../models/todo_item.dart';

// class TodoBloc extends Bloc<TodoEvent, TodoState> {

//  final TodoDatabase todoDatabase;
//   //final TodoService todoService;

//   TodoBloc(this.todoDatabase) : super(const TodoState()) {


//    //add(LoadTodos());

//     on<AddTodo>((event, emit) {
//       emit(TodoState(todos: List.from(state.todos)..add(event.todo)));
//     });

//     on<ToggleTodoStatus>((event, emit) {
//       final updatedTodos = state.todos.map((todo) {
//         if (todo.id == event.id) {
//           return todo.copyWith(isCompleted: !todo.isCompleted);
//         }
//         return todo;
//       }).toList();
//       emit(TodoState(todos: updatedTodos));
//     });

//     on<LoadTodos>((event,emit) async {

//       emit(TodoLoading());
//     try {
//       final todos = await todoDatabase.readAllTodos();
//       emit(TodoLoaded(todos));
//     } catch (e) {
//       emit(TodoError('failed'));
//     }
//     });
    


//     on<DeleteTodo>((event, emit) {
//       final updatedTodos = state.todos.where((todo) => todo.id != event.id).toList();
//       emit(TodoState(todos: updatedTodos));
//     });
//   }
// }

//with dio

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../database/todo_database.dart';
import '../services/todo_service.dart';
import '../models/todo_item.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoDatabase todoDatabase;
  final TodoService todoService;
  List<TodoItem> todos = [];

  TodoBloc(this.todoDatabase, this.todoService) : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<ToggleTodoStatus>(_onToggleTodoStatus);
    on<DeleteTodo>(_onDeleteTodo);
  }

  // Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
  //   emit(TodoLoading());
  //   print('todo loading');
  //   try {
  //     final todos = await todoDatabase.readAllTodos();
  //     print('fetching data locally');
  //     emit(TodoLoaded(todos));
  //   } catch (e) {
  //     emit(TodoError('Failed to fetch data from locally'));
  //   }
  //
  //   try {
  //     List<TodoItem> todos = await todoService.fetchTodos();
  //     print('fetching the data ${todos} network');
  //     emit(TodoLoaded(todos));
  //   } catch (e) {
  //     emit(TodoError('Failed to fetch todo from network'));
  //   }
  // }

// Fetch todos from both local and remote and emit combined data
//   Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
//     try {
//       final todos = await todoService.fetchTodos();
//       emit(TodoLoaded(todos as List<TodoItem>));
//
//     } catch (e) {
//       emit(TodoError("Failed to fetch todos"));
//     }
//   }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {

      final todos = await todoService.fetchTodos();
      todos.fold((failure) => emit(TodoError(failure.message)), // Handle local error
            (todos) => emit(TodoLoaded(todos)),  // Load local todos)
      );


  }

  // Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
  //   emit(TodoLoading());
  //
  //   final localResult = await todoService.fetchTodos();
  //   localResult.fold(
  //         (failure) => emit(TodoError(failure.message)), // Handle local error
  //         (todos) => emit(TodoLoaded(todos)),            // Load local todos
  //   );
  //
  //   final remoteResult = await todoService.fetchTodos();
  //   remoteResult.fold(
  //         (failure) => emit(TodoError(failure.message)), // Handle remote error
  //         (todos) => emit(TodoLoaded(todos)),            // Load remote todos
  //   );
  // }
  // }


  // Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
  //   try {
  //     await todoDatabase.addTodo(event.todo); // Add locally
  //     await todoService.addTodoRemote(event.todo); // Sync with server
  //     add(LoadTodos());
  //     debugPrint('data added ');
  //   } catch (e) {
  //     emit(TodoError('Failed to add todo'));
  //   }
  // }




  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      final List<TodoItem> updatedTodos = List.from((state as TodoLoaded).todos);
      final newTodo = TodoItem(

        id: event.todo.id,
        title: event.todo.title,

        isCompleted: event.todo.isCompleted,
      );

      try {
       // await repository.insertTodoRemotely(newTodo);
        await todoDatabase.addTodo(newTodo);
        debugPrint('added data locally ${newTodo}');
      } catch (_) {
        //await repository.insertTodoLocally(newTodo);
        await todoService.addTodoRemote(newTodo);
        debugPrint('added data remotellly = ${newTodo}');
      }

      updatedTodos.add(newTodo);
      emit(TodoLoaded(updatedTodos));

    }
  }





  Future<void> _onToggleTodoStatus(ToggleTodoStatus event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      final updatedTodos = (state as TodoLoaded).todos.map((todo) {
        if (todo.id == event.id) {
          final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
          todoDatabase.update(updatedTodo);
          return updatedTodo;
        }
        return todo;
      }).toList();

      emit(TodoLoaded(updatedTodos));
    }
  }



  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      try {
        await todoDatabase.delete(event.id);
        debugPrint('deleted data locally');
      } catch (_) {
        await todoService.deleteTodoRemote(event.id);
        debugPrint('deleted data remotely');

      }

      final updatedTodos = (state as TodoLoaded).todos.where((todo) => todo.id != event.id).toList();
      emit(TodoLoaded(updatedTodos));
    }
  }

}
