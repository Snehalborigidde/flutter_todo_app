import 'package:pigeon/pigeon.dart';

class TodoItem {
  late int id;
  late String title;
  late bool isCompleted;
}

@HostApi()
abstract class TodoApi {
  List<TodoItem> getTodos();
  void addTodo(TodoItem todo);
  void deleteTodo(int id);
}
