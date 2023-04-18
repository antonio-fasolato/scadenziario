import 'package:flutter/material.dart';
import 'package:scadenziario/components/footer.dart';

class CalendarScene extends StatelessWidget {
  const CalendarScene({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scadenziario - Calendario"),
      ),
      body: const Center(
        child: Text("Calendario"),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
