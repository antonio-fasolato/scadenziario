import 'package:flutter/material.dart';
import 'package:scadenziario/components/footer.dart';

class DatabaseSelectionScene extends StatelessWidget {
  const DatabaseSelectionScene({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scadenziario - Selezione archivio di lavoro"),
      ),
      body: Center(
        child: Column(
          children: [
            const Text("Selezione database"),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("/home", (route) => false);
                },
                child: const Text("Seleziona database"))
          ],
        ),
      ),
      // bottomNavigationBar: const Footer(),
    );
  }
}
