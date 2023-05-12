import 'package:flutter/material.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';
import 'package:scadenziario/scenes/courses_scene.dart';
import 'package:scadenziario/scenes/calendar_scene.dart';
import 'package:scadenziario/scenes/database_selection_scene.dart';
import 'package:scadenziario/scenes/homepage_scene.dart';
import 'package:scadenziario/scenes/persons_scene.dart';
import 'package:scadenziario/scenes/settings_scene.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  initializeDateFormatting('it_IT', null).then((_) => runApp(Scadenziario(
        sharedPreferences: sharedPreferences,
      )));
}

class Scadenziario extends StatefulWidget {
  final SharedPreferences _sharedPreferences;

  const Scadenziario({super.key, required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  @override
  State<Scadenziario> createState() => _ScadenziarioState();
}

class _ScadenziarioState extends State<Scadenziario> {
  SqliteConnection? _connection;

  void _setConnection(SqliteConnection connection) {
    setState(() {
      _connection = connection;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scadenziario',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      routes: {
        "/": (buildContext) => DatabaseSelectionScene(
              sharedPreferences: widget._sharedPreferences,
              setSqliteConnection: _setConnection,
            ),
        "/home": (buildContext) => const HomepageScene(),
        "/people": (buildContext) =>
            PersonsScene(connection: _connection as SqliteConnection),
        "/calendar": (buildContext) => const CalendarScene(),
        "/activities": (buildContext) => CoursesScene(
              connection: _connection as SqliteConnection,
            ),
        "/settings": (buildContext) => SettingsScene(),
      },
      initialRoute: '/',
    );
  }
}
