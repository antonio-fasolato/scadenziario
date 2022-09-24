import 'package:flutter/material.dart';
import 'page_2_scene.dart';

class Page1Scene extends StatelessWidget {
  const Page1Scene({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("Details:"),
          ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, "/Edit"),
              child: const Text("Edit"))
        ],
      )),
    );
  }
}
