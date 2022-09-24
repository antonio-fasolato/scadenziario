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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Page 1"),
            IconButton(
              onPressed: () => Navigator.pop(context), 
              icon: const Icon(Icons.arrow_back)
            )
          ],
        )
      ),
    );
  }
}
