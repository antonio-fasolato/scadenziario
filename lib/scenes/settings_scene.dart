import 'package:flutter/material.dart';
import 'package:scadenziario/components/footer.dart';
import 'package:scadenziario/components/options_defaults.dart';
import 'package:scadenziario/components/options_roles.dart';

class SettingsScene extends StatelessWidget {
  const SettingsScene({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scadenziario - Opzioni"),
      ),
      body: SingleChildScrollView(
        child: Table(
          children: const [
            TableRow(
              children: [
                TableCell(
                  child: OptionsRoles(),
                ),
                TableCell(
                  child: OptionsDefaults(),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
