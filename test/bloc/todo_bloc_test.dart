

import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todo_app/models/failure.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_todo_app/bloc/todo_bloc.dart';
import 'package:flutter_todo_app/bloc/todo_event.dart';
import 'package:flutter_todo_app/bloc/todo_state.dart';
import 'package:flutter_todo_app/models/todo_item.dart';
import 'package:flutter_todo_app/services/todo_service.dart';
import 'package:flutter_todo_app/database/todo_database.dart';

// Mock the TodoService and TodoDatabase
class MockTodoService extends Mock implements TodoService {}
class MockTodoDatabase extends Mock implements TodoDatabase {}

void main() {
  late TodoBloc todoBloc;
  late MockTodoService mockService;
  late MockTodoDatabase mockDatabase;

  setUp(() {
    mockService = MockTodoService();
    mockDatabase = MockTodoDatabase();
    todoBloc = TodoBloc(mockDatabase, mockService);
  });



  test('initial state is TodoInitial', () {
    expect(todoBloc.state, equals(TodoInitial())); // Updated to TodoInitial
  });



  group('AddTodo', () {
    final newTodo = TodoItem(id: 1, title: 'New Todo', isCompleted: false);

    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoading, TodoLoaded] when AddTodo is successful',
      build: () {
        // Mock database and service methods to return valid futures
        when(mockDatabase.addTodo(newTodo)).thenAnswer((_) async => true);
        when(mockService.addTodoRemote(newTodo)).thenAnswer((_) async => true);

        // Ensure that readAllTodos returns a non-null list
       // when(mockDatabase.readAllTodos()).thenAnswer((_) async => [newTodo]);

        return todoBloc;
      },
      act: (bloc) {
        bloc.emit(TodoLoaded([])); // Start from TodoLoaded state
        bloc.add(AddTodo(newTodo));
      },
      expect: () => [
        TodoLoading(),
        isA<TodoLoaded>().having((state) => state.todos.contains(newTodo), 'contains new todo', true),
      ],
    );
  });


}








