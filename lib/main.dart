import 'package:flutter/material.dart';

void main() {
  runApp(const Scadenziario());
}

class Scadenziario extends StatelessWidget {
  const Scadenziario({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ScadenziarioWidget(title: 'Flutter Demo Home Page'),
    );
  }
}

class ScadenziarioWidget extends StatefulWidget {
  const ScadenziarioWidget({super.key, required this.title});

  final String title;

  @override
  State<ScadenziarioWidget> createState() => _ScadenziarioWidgetState();
}

class _ScadenziarioWidgetState extends State<ScadenziarioWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Main widget',
            ),
          ],
        ),
      ),
    );
  }
}
