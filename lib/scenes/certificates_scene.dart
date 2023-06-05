import 'package:flutter/material.dart';
import 'package:scadenziario/components/footer.dart';

class CertificateScene extends StatelessWidget {
  const CertificateScene({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scadenziario - Certificati"),
      ),
      body: Container(),
      bottomNavigationBar: const Footer(),
    );
  }
}
