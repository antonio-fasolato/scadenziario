import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  final String _title;

  const AppBarTitle({super.key, required String title}) : _title = title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(_title),
        const SizedBox(width: 16),
        Tooltip(
          message: "Hai delle notifiche",
          child: IconButton(
            onPressed: () => Navigator.of(context).pushNamed("/notifications"),
            color: Colors.redAccent,
            icon: const Icon(Icons.notification_important_outlined),
          ),
        ),
      ],
    );
  }
}
