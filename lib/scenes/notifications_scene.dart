import 'package:flutter/material.dart';
import 'package:scadenziario/components/app_bar_title.dart';
import 'package:scadenziario/components/footer.dart';

class NotificationsScene extends StatelessWidget {
  const NotificationsScene({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: "Scadenziario - notifiche"),
      ),
      body: const Text("Notifiche"),
      bottomNavigationBar: const Footer(),
    );
  }
}
