import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';
import 'package:scadenziario/scenes/certification_scene.dart';
import 'package:scadenziario/scenes/courses_scene.dart';
import 'package:scadenziario/scenes/calendar_scene.dart';
import 'package:scadenziario/scenes/database_selection_scene.dart';
import 'package:scadenziario/scenes/homepage_scene.dart';
import 'package:scadenziario/scenes/persons_scene.dart';
import 'package:scadenziario/scenes/settings_scene.dart';
import 'package:scadenziario/state/course_state.dart';
import 'package:scadenziario/state/person_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.time}: ${record.level.name} [${record.loggerName}]: ${record.message}');
  });
  Logger.root.level = Level.WARNING;
  if (kDebugMode) {
    Logger.root.level = Level.ALL;
    var log = Logger('main');
    log.info("Application started in debug mode");
  }

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  initializeDateFormatting('it_IT', null).then(
    (_) => runApp(
      Scadenziario(
        sharedPreferences: sharedPreferences,
      ),
    ),
  );
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
  final courseState = CourseState();

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
        "/people": (buildContext) => ChangeNotifierProvider<PersonState>(
              create: (context) => PersonState(),
              child: PersonsScene(connection: _connection as SqliteConnection),
            ),
        "/calendar": (buildContext) => const CalendarScene(),
        "/courses": (buildContext) => ChangeNotifierProvider<CourseState>.value(
              value: courseState,
              child: CoursesScene(
                connection: _connection as SqliteConnection,
              ),
            ),
        "/settings": (buildContext) => SettingsScene(),
        "/certificates": (buildContext) =>
            ChangeNotifierProvider<CourseState>.value(
              value: courseState,
              child:
                  CertificateScene(connection: _connection as SqliteConnection),
            )
      },
      initialRoute: '/',
    );
  }
}
