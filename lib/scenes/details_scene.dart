import 'package:flutter/material.dart';

class DetailsScene extends StatefulWidget {
  const DetailsScene({super.key, required this.title});

  final String title;

  @override
  State<DetailsScene> createState() => _DetailSceneState();
}

class _DetailSceneState extends State<DetailsScene> {
  String _data = "Valore iniziale";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Details: $_data"),
          ElevatedButton(
              onPressed: () {
                _navigateAndDisplay(context);
              },
              child: const Text("Edit"))
        ],
      )),
    );
  }

  Future<void> _navigateAndDisplay(BuildContext context) async {
    final result = await Navigator.pushNamed(context, "/Edit");
    if (!mounted) return;
    setState(() {
      _data = result as String;
    });
  }
}
