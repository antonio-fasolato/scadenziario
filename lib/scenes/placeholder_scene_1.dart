import 'package:flutter/material.dart';

class PlaceholderScene1 extends StatelessWidget {
  const PlaceholderScene1({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const Center(child: Text("Placeholder 1")),
    );
  }
}
