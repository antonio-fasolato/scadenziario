import 'package:flutter/material.dart';
import 'package:scadenziario/components/footer.dart';
import 'package:scadenziario/components/scadenziario_app_bar.dart';
import 'package:scadenziario/components/settings_defaults.dart';
import 'package:scadenziario/components/settings_roles.dart';

class SettingsScene extends StatelessWidget {
  const SettingsScene({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScadenziarioAppBar("Scadenziario - Opzioni"),
      body: SingleChildScrollView(
        child: Table(
          children: const [
            TableRow(
              children: [
                TableCell(
                  child: SettingsRoles(),
                ),
                TableCell(
                  child: SettingsDefaults(),
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
