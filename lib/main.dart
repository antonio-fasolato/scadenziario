import 'package:flutter/material.dart';
import 'package:scadenziario/scenes/activities_scene.dart';
import 'package:scadenziario/scenes/calendar_scene.dart';
import 'package:scadenziario/scenes/database_selection_scene.dart';
import 'package:scadenziario/scenes/homepage_scene.dart';
import 'package:scadenziario/scenes/people_scene.dart';

void main() {
  runApp(const Scadenziario());
}

class Scadenziario extends StatelessWidget {
  const Scadenziario({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scadenziario',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      routes: {
        "/": (buildContext) => const DatabaseSelectionScene(),
        "/home": (buildContext) => const HomepageScene(),
        "/people": (buildContext) => PeopleScene(),
        "/calendar": (buildContext) => const CalendarScene(),
        "/activities": (buildContext) => const ActivitiesScene(),
      },
      initialRoute: '/',
    );
  }
}
