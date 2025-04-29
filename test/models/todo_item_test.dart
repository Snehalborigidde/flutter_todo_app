import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todo_app/models/todo_item.dart';

void main() {
  group('TodoItem Model', () {
    test('TodoItem creation', () {
      // Test if the TodoItem can be created correctly
      final todo = TodoItem(id: 1, title: 'Test Todo', isCompleted: false);

      expect(todo.id, 1);
      expect(todo.title, 'Test Todo');
      expect(todo.isCompleted, false);
    });

    test('Equality of TodoItem', () {
      // Test if two TodoItem objects with the same values are equal
      final todo1 = TodoItem(id: 1, title: 'Test Todo', isCompleted: false);
      final todo2 = TodoItem(id: 1, title: 'Test Todo', isCompleted: false);

      expect(todo1, todo2);  // Using the `==` operator from `freezed` for equality comparison
    });

    test('TodoItem serialization to JSON', () {
      // Test if TodoItem can be serialized to JSON correctly
      final todo = TodoItem(id: 1, title: 'Test Todo', isCompleted: false);
      final json = todo.toJson();

      expect(json, {
        'id': 1,
        'title': 'Test Todo',
        'isCompleted': false,
      });
    });

    test('TodoItem deserialization from JSON', () {
      // Test if TodoItem can be deserialized from JSON correctly
      final json = {
        'id': 1,
        'title': 'Test Todo',
        'isCompleted': false,
      };

      final todo = TodoItem.fromJson(json);

      expect(todo.id, 1);
      expect(todo.title, 'Test Todo');
      expect(todo.isCompleted, false);
    });


    test('TodoItem fromMap conversion', () {
      // Test if TodoItem can be created from a map for SQLite correctly
      final map = {
        'id': 1,
        'title': 'Test Todo',
        'is_completed': 1,  // Converting int (1) to bool (true)
      };

      final todo = TodoItem.fromMap(map);

      expect(todo.id, 1);
      expect(todo.title, 'Test Todo');
      expect(todo.isCompleted, true);  // Expecting the value of 'isCompleted' to be true
    });
  });
}
