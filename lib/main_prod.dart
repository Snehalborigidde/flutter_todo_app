// lib/main_prod.dart
import 'package:flutter/material.dart';
import 'config/flavor.dart';
import 'pages/todo_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_app/bloc/todo_bloc.dart';
import 'package:flutter_todo_app/database/todo_database.dart';
import 'bloc/todo_event.dart';
import 'services/todo_service.dart';

void main() {

  // Initialize the FlavorConfig
  FlavorConfig.initialize(
      flavor: Flavor.production, name: 'Production', apiBaseUrl: 'https://api.todo.com'
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<TodoBloc>(
          create: (context) => TodoBloc(TodoDatabase.instance, TodoService())..add(LoadTodos()),
        ),
        // Add other providers or blocs if needed
      ],
      child: MyApp(),
    ),
  );
}
