import 'package:flutter/material.dart';
import 'package:scadenziario/components/app_bar_title.dart';
import 'package:scadenziario/components/footer.dart';
import 'package:scadenziario/components/settings_defaults.dart';
import 'package:scadenziario/components/settings_roles.dart';

class SettingsScene extends StatelessWidget {
  const SettingsScene({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: "Scadenziario - Opzioni"),
      ),
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
