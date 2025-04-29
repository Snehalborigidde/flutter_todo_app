


//this work w/o checkbox

import 'package:equatable/equatable.dart';
import 'package:flutter_todo_app/models/todo_item.dart';



sealed class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class AddTodo extends TodoEvent {
  final TodoItem todo;

  const AddTodo(this.todo);

  @override
  List<Object> get props => [todo];
}

class ToggleTodoStatus extends TodoEvent {
  final int id;

  ToggleTodoStatus(this.id);

  @override
  List<Object> get props => [id];
}

class LoadTodos extends TodoEvent {}


class DeleteTodo extends TodoEvent {
  final int id;

  DeleteTodo(this.id);

  @override
  List<Object> get props => [id];
}




