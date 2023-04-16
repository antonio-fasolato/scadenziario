import 'package:flutter/material.dart';
import 'package:scadenziario/components/footer.dart';

class PeopleScene extends StatelessWidget {
  const PeopleScene({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scadenziario - Personale"),
      ),
      body: const Center(
        child: Text("Personale"),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
