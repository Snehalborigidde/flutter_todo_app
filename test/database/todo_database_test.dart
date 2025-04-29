
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_todo_app/models/todo_item.dart';
import 'package:flutter_todo_app/database/todo_database.dart';

// Create a mock class for TodoDatabase
class MockTodoDatabase extends Mock implements TodoDatabase {}

void main() {
  late MockTodoDatabase mockDatabase;

  setUp(() {
    mockDatabase = MockTodoDatabase();
  });

  test('Add Todo item to database', () async {
    final todo = TodoItem(id: 1, title: 'Test Todo', isCompleted: false);

    // Mock the addTodo method
    when(() => mockDatabase.addTodo(todo)).thenAnswer((_) async => true);

    // Call the addTodo method and verify it was called
    await mockDatabase.addTodo(todo);
    verify(() => mockDatabase.addTodo(todo)).called(1);
  });

  test('Fetch Todos from database', () async {
    final todo1 = TodoItem(id: 1, title: 'Todo 1', isCompleted: false);
    final todo2 = TodoItem(id: 2, title: 'Todo 2', isCompleted: true);

    // Mock the readAllTodos method
    when(() => mockDatabase.readAllTodos()).thenAnswer((_) async => [todo1, todo2]);

    // Fetch todos and verify the result
    final todos = await mockDatabase.readAllTodos();
    expect(todos, contains(todo1));
    expect(todos, contains(todo2));
  });

  test('Delete Todo item from database', () async {
    final todo = TodoItem(id: 1, title: 'Test Todo', isCompleted: false);

    // Mock the delete method
    when(() => mockDatabase.delete(todo.id)).thenAnswer((_) async => true);

    // Call the delete method and verify it was called
    await mockDatabase.delete(todo.id);
    verify(() => mockDatabase.delete(todo.id)).called(1);
  });
}
