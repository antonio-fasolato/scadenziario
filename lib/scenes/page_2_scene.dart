import 'package:flutter/material.dart';

class Page2Scene extends StatelessWidget {
  const Page2Scene({super.key, required this.title});

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
          const Text("Editor"),
          ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Confirm"))
        ],
      )),
    );
  }
}
