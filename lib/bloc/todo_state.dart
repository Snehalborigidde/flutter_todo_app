



//working wo checkbox

import 'package:equatable/equatable.dart';
import 'package:flutter_todo_app/models/todo_item.dart';



sealed class TodoState extends Equatable {
  final List<TodoItem> todos;

  const TodoState({this.todos = const []});

  @override
  List<Object> get props => [todos];
}

class TodoInitial extends TodoState{}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<TodoItem> todos;
  TodoLoaded(this.todos);
}

class TodoError extends TodoState {
  final String message;

  const TodoError(this.message);
}