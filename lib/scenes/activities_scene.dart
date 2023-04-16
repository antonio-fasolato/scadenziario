import 'package:flutter/material.dart';
import 'package:scadenziario/components/footer.dart';

class ActivitiesScene extends StatelessWidget {
  const ActivitiesScene({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scadenziario - Atività e corsi"),
      ),
      body: const Center(
        child: Text("Attività e corsi"),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
