import 'package:flutter/material.dart';
import 'package:scadenziario/scenes/database_selection_scene.dart';

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
      routes: {"/": (buildContext) => DatabaseSelectionScene()},
      initialRoute: '/',
    );
  }
}
