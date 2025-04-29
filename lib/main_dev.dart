// lib/main_dev.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_app/bloc/todo_bloc.dart';
import 'package:flutter_todo_app/database/todo_database.dart';
import 'bloc/todo_event.dart';
import 'config/app_config.dart';
import 'config/flavor.dart';
import 'pages/todo_page.dart';
import 'services/todo_service.dart';

void main() {

  //FlavorConfig(flavor: Flavor.development, name: 'Development', apiBaseUrl: 'https://dev.api.todo.com');
  // Initialize the FlavorConfig
  FlavorConfig.initialize(
      flavor: Flavor.development, name: 'Development', apiBaseUrl: 'https://dev.api.todo.com'
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



