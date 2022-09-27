import 'package:flutter/material.dart';

class LandingScene extends StatelessWidget {
  const LandingScene({super.key, required this.title});

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
            const Text(
              'Landing screen:',
            ),
            IconButton(
                onPressed: () => Navigator.pushNamed(context, '/Detail'),
                icon: const Icon(Icons.forward))
          ],
        ),
      ),
      drawer: Drawer(
          child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.forward),
            title: const Text("Avanti"),
            onTap: () {
              Navigator.pushNamed(context, "/Detail");
            },
          ),
        ],
      )),
    );
  }
}
