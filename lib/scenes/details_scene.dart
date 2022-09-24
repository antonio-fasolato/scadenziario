import 'package:flutter/material.dart';

class DetailsScene extends StatelessWidget {
  const DetailsScene({super.key, required this.title});

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
