import 'dart:math';

import 'package:either_dart/src/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_app/bloc/todo_bloc.dart';
import 'package:flutter_todo_app/bloc/todo_event.dart';
import 'package:flutter_todo_app/bloc/todo_state.dart';
import 'package:flutter_todo_app/database/todo_database.dart';
import 'package:flutter_todo_app/models/failure.dart';
import 'package:flutter_todo_app/models/todo_item.dart';
import 'package:flutter_todo_app/mixin/validation_mixin.dart';
import 'package:flutter_todo_app/pages/todo_details_page.dart';
import 'package:flutter_todo_app/pages/todo_list_page.dart';
import 'package:flutter_todo_app/services/todo_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../config/app_config.dart';
import '../themes/todo_theme.dart';
import 'login.dart';

//for flavors
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadLocale();
    _loadTheme();
  }

  //themes
  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? theme = prefs.getString('themeMode');
    setState(() {
      _themeMode = theme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> _saveTheme(ThemeMode themeMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'themeMode', themeMode == ThemeMode.dark ? 'dark' : 'light');
  }

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
    _saveTheme(_themeMode);
  }

//localization
  Future<void> _loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('languageCode');
    setState(() {
      _locale = languageCode != null ? Locale(languageCode) : Locale('en');
    });
  }

  void _setLocale(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: _themeMode,
      title: '${AppConfig.flavorName} - Todo App',
      locale: _locale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('en'), Locale('hi')],
      home: LoginPage(
        onLocaleChanged: _setLocale,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> with ValidationMixin {
  final TextEditingController _todoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  String _username = '';
  String? _errorMessage;
  final TodoService _todoService = TodoService();
  final TodoDatabase _todoDatabase = TodoDatabase();
  List<TodoItem> _todos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _fetchData();
    context.read<TodoBloc>().add(LoadTodos());
    print('fetching data');
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _username = prefs.getString('username') ?? 'Guest';
      });
    }
  }



  Future<void> _fetchData() async {
    debugPrint('fetch data method called');

    // Fetch remote todos
    final result = await _todoService.fetchTodos();
    result.fold(
      (failure) {
        // Handle failure, show an error message
        debugPrint(failure.message);
        setState(() {
          _todos = []; // Or show an error message in the UI
          _isLoading = false;
        });
      },
      (todos) {
        // On success, update the todos list
        debugPrint('Fetched updated todos = $todos');
        setState(() {
          _todos = todos; // Unwrap the Right to get the List<TodoItem>
          _isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();

    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${AppLocalizations.of(context)!.welcomeMessage(_username)} ${AppConfig.flavorName}-${AppLocalizations.of(context)!.appTitle}',
          style: const TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              focusNode: focusNode,
              controller: _todoController,
              decoration: InputDecoration(
                labelText: 'Enter Title',
                hintText: 'title',
                errorText: _errorMessage,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          //print();
          ElevatedButton(
            onPressed: () {
              print('newtodo...............');
              _addTodo();
              scaffoldMessengerKey.currentState?.showSnackBar(
                SnackBar(content: Text('Todo added successfully!')),
              );
              // Dismiss the keyboard
              FocusScope.of(context).unfocus();
            },
            child: Text(AppLocalizations.of(context)!.addTodo),
          ),

          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
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
          ),
        ],
      ),
    );
  }

  void _addTodo() {
    print('newtodo added');
    final title = _todoController.text;

    // Validate the title using ValidatorMixin
    final error = validateTitle(title);
    if (error != null) {
      if (mounted) {
        setState(() {
          _errorMessage = error;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _errorMessage = null;
        });
      }
      final id = Random().nextInt(10000);
      bool? isCompleted;
      final status = isCompleted ?? false;
      final newTodo = TodoItem(
        id: id,
        title: title,
        isCompleted: status,
      );
      print('${newTodo}newtodo added');
      context.read<TodoBloc>().add(AddTodo(newTodo));
      debugPrint('new todo added');
      _todoController.clear();
      // Fetch updated list
      _fetchData();
    }
  }

  void _navigateToDetails(TodoItem todo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TodoDetailsPage(todo: todo),
      ),
    );
  }



  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }
}

