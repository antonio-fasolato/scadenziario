import 'package:flutter/material.dart';
import 'package:scadenziario/components/footer.dart';

class HomepageScene extends StatelessWidget {
  const HomepageScene({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scadenziario - Pagina inziale"),
      ),
      body: const Center(
        child: Text("Homepage"),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
