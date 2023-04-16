import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.blueGrey,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          children: <Widget>[
            IconButton(
              tooltip: "Personale",
              icon: const Icon(Icons.people),
              onPressed: () {
                Navigator.of(context).pushNamed("/");
              },
            ),
            IconButton(
              tooltip: "Calendario",
              icon: const Icon(Icons.calendar_month),
              onPressed: () {
                Navigator.of(context).pushNamed("/");
              },
            ),
            IconButton(
              tooltip: "Attività e corsi",
              icon: const Icon(Icons.business_center),
              onPressed: () {
                Navigator.of(context).pushNamed("/");
              },
            ),
            const Spacer(),
            IconButton(
              tooltip: "Cambia archivio",
              icon: const Icon(Icons.save),
              onPressed: () {
                Navigator.of(context).pushNamed("/");
              },
            ),
          ],
        ),
      ),
    );
  }
}
