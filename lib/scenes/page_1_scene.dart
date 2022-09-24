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
          const Text("Page 1"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back)),
              IconButton(
                  onPressed: () => Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              Page2Scene(title: title))),
                  icon: const Icon(Icons.forward))
            ],
          ),
        ],
      )),
    );
  }
}
