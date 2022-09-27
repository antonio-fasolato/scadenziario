import 'package:flutter/material.dart';

class PlaceholderScene2 extends StatelessWidget {
  const PlaceholderScene2({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const Center(child: Text("Placeholder 2")),
    );
  }
}
