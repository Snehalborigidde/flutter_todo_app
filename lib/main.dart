// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_todo/bloc/todo_bloc.dart';
// import 'package:flutter_todo/bloc/todo_event.dart';
// import 'package:flutter_todo/database/todo_database.dart';
// import 'package:flutter_todo/pages/todo_page.dart';
// import 'package:flutter_todo/themes/todo_theme.dart';

// void main() {
//   runApp( MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: lightTheme,
//       darkTheme: darkTheme,
//       themeMode: ThemeMode.system,
//       title: 'Flutter ToDo App',
//       home: BlocProvider(
//         create: (context) => TodoBloc(TodoDatabase.instance)..add(LoadTodos()),
//         child: TodoHomePage(),
//       ),
//     );
//   }
// }


//with dio
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_app/bloc/todo_bloc.dart';
import 'package:flutter_todo_app/bloc/todo_event.dart';
import 'package:flutter_todo_app/database/todo_database.dart';
import 'package:flutter_todo_app/pages/login.dart';
import 'package:flutter_todo_app/pages/todo_page.dart';
import 'package:flutter_todo_app/services/todo_service.dart';
import 'package:flutter_todo_app/themes/todo_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // runApp( MyApp());
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
    await prefs.setString('themeMode', themeMode == ThemeMode.dark ? 'dark' : 'light');
  }

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
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
      title: 'ToDo App',
      locale: _locale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('en'), Locale('hi')],
      home: LoginPage(onLocaleChanged: _setLocale,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

