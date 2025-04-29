import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_app/pages/todo_details_page.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import '../models/todo_item.dart';

class TodoListPage extends StatefulWidget {
  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      // body: BlocBuilder<TodoBloc, TodoState>(
      //   builder: (context, state) {
      //     if (state is TodoLoading) {
      //       return Center(child: CircularProgressIndicator());
      //     } else if (state is TodoLoaded) {
      //       return ListView.builder(
      //         itemCount: state.todos.length,
      //         itemBuilder: (context, index) {
      //           final todo = state.todos[index];
      //           // itemCount: _todos.length,
      //           // itemBuilder: (context, index) {
      //           // final todo = _todos[index];
      //           return ListTile(
      //             title: Text(
      //               todo.title,
      //               style: TextStyle(
      //                 decoration: todo.isCompleted
      //                     ? TextDecoration.lineThrough
      //                     : TextDecoration.none,
      //               ),
      //             ),
      //             leading: Checkbox(
      //               value: todo.isCompleted,
      //               onChanged: (bool? newValue) {
      //                 context.read<TodoBloc>().add(ToggleTodoStatus(todo.id));
      //               },
      //             ),
      //             // Navigate to details page on tap
      //             onTap: () => _navigateToDetails(todo),
      //             trailing: IconButton(
      //               icon: const Icon(Icons.delete, color: Colors.red),
      //               onPressed: () {
      //                 context.read<TodoBloc>().add(DeleteTodo(todo.id));
      //               },
      //             ),
      //           );
      //         },
      //       );
      //     } else if (state is TodoError) {
      //       return Center(child: Text(state.message));
      //     }
      //     return Container();
      //   },
      // ),
     body:  BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          // if (state.todos.isEmpty) {
          //   return const Center(child: Text('No ToDo items.'));
          // }

          return ListView.builder(
            itemCount: state.todos.length,
            itemBuilder: (context, index) {
              final todo = state.todos[index];
              return ListTile(
                title: Text(
                  todo.title,
                  style: TextStyle(
                    decoration: todo.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                leading: Checkbox(
                  value: todo.isCompleted,
                  onChanged: (bool? newValue) {
                    context
                        .read<TodoBloc>()
                        .add(ToggleTodoStatus(todo.id));
                  },
                ),
                // Navigate to details page on tap
                onTap: () => _navigateToDetails(todo),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    context.read<TodoBloc>().add(DeleteTodo(todo.id));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToDetails(TodoItem todo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TodoDetailsPage(todo: todo),
      ),
    );
  }
}
