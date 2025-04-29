

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_app/database/todo_database.dart';
import 'package:flutter_todo_app/pages/todo_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../bloc/todo_bloc.dart';
import '../config/app_config.dart';
import '../services/todo_service.dart';

class LoginPage extends StatefulWidget {
  final Function(Locale) onLocaleChanged;
  final VoidCallback onToggleTheme;

 // const LoginPage({Key? key, required this.onLocaleChanged}) : super(key: key);

  const LoginPage({
    Key? key,
    required this.onLocaleChanged,
    required this.onToggleTheme,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _toggleLanguage(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentLanguage = prefs.getString('languageCode') ?? 'en';
    Locale newLocale = currentLanguage == 'en' ? Locale('hi') : Locale('en');
    widget.onLocaleChanged(newLocale);
  }

  Future<void> _login() async {
    // For example: Assume login is successful when username and password are not empty
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      // Save username in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);

      // Navigate to Home Page
     // Navigator.pushReplacementNamed(context, '/home');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => TodoBloc(TodoDatabase.instance, TodoService()),
            child: TodoHomePage(),
          ),
        ),);
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid credentials')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${AppLocalizations.of(context)!.login}, ${AppConfig.flavorName} - ${AppLocalizations.of(context)!.appTitle}'),
          actions: [
            //language button
          IconButton(
          icon: Icon(Icons.language),
      onPressed: () => _toggleLanguage(context),
    ),
            // Theme Toggle
            IconButton(
              icon: Icon(Icons.brightness_6),
              onPressed: widget.onToggleTheme,
            ),
    ],
      ),


      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text(AppLocalizations.of(context)!.login),
            ),
          ],
        ),
      ),
    );
  }
}




