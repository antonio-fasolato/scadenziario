import 'package:flutter/material.dart';
import 'package:scadenziario/scenes/activities_scene.dart';
import 'package:scadenziario/scenes/calendar_scene.dart';
import 'package:scadenziario/scenes/database_selection_scene.dart';
import 'package:scadenziario/scenes/homepage_scene.dart';
import 'package:scadenziario/scenes/people_scene.dart';
import 'package:scadenziario/scenes/settings_scene.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  initializeDateFormatting('it_IT', null).then((_) => runApp(Scadenziario(
        sharedPreferences: sharedPreferences,
      )));
}

class Scadenziario extends StatelessWidget {
  final SharedPreferences _sharedPreferences;

  const Scadenziario({super.key, required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scadenziario',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      routes: {
        "/": (buildContext) => DatabaseSelectionScene(
              sharedPreferences: _sharedPreferences,
            ),
        "/home": (buildContext) => const HomepageScene(),
        "/people": (buildContext) => PeopleScene(),
        "/calendar": (buildContext) => const CalendarScene(),
        "/activities": (buildContext) => ActivitiesScene(),
        "/settings": (buildContext) => SettingsScene(),
      },
      initialRoute: '/',
    );
  }
}
