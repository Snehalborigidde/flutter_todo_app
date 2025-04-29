import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_item.freezed.dart';
part 'todo_item.g.dart';

@freezed
class TodoItem with _$TodoItem {
  const factory TodoItem({
    required int id,
    required String title,
    @JsonKey(name: "isCompleted", defaultValue: false) @Default(false) required bool isCompleted,
  }) = _TodoItem;

  // Factory method to create TodoItem from a Map
  factory TodoItem.fromJson(Map<String, dynamic> json) => _$TodoItemFromJson(json);


  // Method to convert TodoItem to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'is_completed': isCompleted ? 1 : 0,  // Convert bool to int
    };
  }

  // Factory method to create TodoItem from a Map
  factory TodoItem.fromMap(Map<String, dynamic> map) {
    return TodoItem(
      id: map['id'] as int,
      title: map['title'] as String,
      isCompleted: (map['is_completed'] as int) == 1,  // Convert int to bool
    );
  }
}
