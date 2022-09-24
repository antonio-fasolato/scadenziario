import 'package:flutter/material.dart';

class EditorScene extends StatelessWidget {
  const EditorScene({super.key, required this.title});

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
              onPressed: () => Navigator.pop(context, "OK"),
              child: const Text("Confirm")),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, "KO"),
              child: const Text("Cancel")),
        ],
      )),
    );
  }
}
