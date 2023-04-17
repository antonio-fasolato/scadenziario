import 'package:flutter/material.dart';
import 'package:scadenziario/components/footer.dart';

class SettingsScene extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scadenziario - Opzioni"),
      ),
      body: const Text("Opzioni"),
      bottomNavigationBar: const Footer(),
    );
  }
}
