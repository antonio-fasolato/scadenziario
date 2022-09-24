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
              onPressed: () => Navigator.pushNamed(context, '/page1'), 
              icon: const Icon(Icons.forward)
            )
          ],
        ),
      ),
    );
  }
}
