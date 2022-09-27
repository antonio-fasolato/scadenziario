import 'package:flutter/material.dart';
import 'scenes/landing_scene.dart';
import 'scenes/details_scene.dart';
import 'scenes/editor_scene.dart';
import 'scenes/placeholder_scene_1.dart';
import 'scenes/placeholder_scene_2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scadenziario',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (BuildContext ctx) => const LandingScene(title: "Scadenziario"),
        '/Detail': (BuildContext ctx) => const DetailsScene(title: "Scadenziario"),
        '/Edit': (BuildContext ctx) => const EditorScene(title: "Scadenziario"),
        '/Placeholder1': (BuildContext ctx) => const PlaceholderScene1(title: "Scadenziario"),
        '/Placeholder2': (BuildContext ctx) => const PlaceholderScene2(title: "Scadenziario"),
      },
      initialRoute: '/',
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
