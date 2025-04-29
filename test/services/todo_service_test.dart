import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_todo_app/services/todo_service.dart';
import 'package:flutter_todo_app/models/todo_item.dart';
import 'package:flutter_todo_app/database/todo_database.dart';
import 'package:flutter_todo_app/models/failure.dart';

class MockDio extends Mock implements Dio {}

class MockTodoDatabase extends Mock implements TodoDatabase {}

void main() {
  late TodoService todoService;
  late MockDio mockDio;
  late MockTodoDatabase mockDatabase;
  const String testBaseUrl = 'https://jsonplaceholder.typicode.com/todos';

  setUp(() {
    mockDio = MockDio();
    mockDatabase = MockTodoDatabase();
    todoService = TodoService(dio: mockDio, database: mockDatabase);
  });

  test('fetchTodos returns remote data when fetch is successful', () async {
    // Arrange: Prepare a mock response for Dio
    final List<TodoItem> remoteTodos = [
      const TodoItem(id: 1, title: 'Remote Todo', isCompleted: false),
    ];
    final response = Response(
      data: remoteTodos.map((todo) => todo.toJson()).toList(),
      requestOptions: RequestOptions(path: testBaseUrl),
      statusCode: 200,
    );

    when(mockDio.get(testBaseUrl)).thenAnswer((_) async => response);

    // Act
    final result = await todoService.fetchTodos();

    // Assert
    expect(result.isRight, true);
    expect(result.right, remoteTodos);
  });

  test('fetchTodos returns Failure when fetching remote data fails', () async {
    // Arrange: Simulate Dio throwing an error
    final error = DioException(
      requestOptions: RequestOptions(path: testBaseUrl),
      error: 'Network error',
    );

    when(mockDio.get(testBaseUrl)).thenThrow(error);

    // Act
    final result = await todoService.fetchTodos();

    // Assert
    expect(result.isLeft, true);
    expect(result.left, isA<Failure>());
    expect(result.left.message, 'Failed to fetch todos from remote source');
  });
}













