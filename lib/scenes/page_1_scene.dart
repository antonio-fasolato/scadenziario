import 'package:flutter/material.dart';

class Page1Scene extends StatelessWidget {
  const Page1Scene({super.key, required this.title});

  final String title;

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const Center(
        child: Text("Page 1"),
      ),
    );
  }
}
