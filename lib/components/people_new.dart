import 'package:flutter/material.dart';

class PeopleNew extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Text("Dati anagrafici",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Form(
              key: _formKey,
              child: Table(
                children: [
                  TableRow(children: [
                    TableCell(child: Text("Nome")),
                    TableCell(child: Text("Cognome"))
                  ]),
                  TableRow(children: [
                    TableCell(child: Text("Data di nascita")),
                    TableCell(child: Text("Mansione"))
                  ]),
                  TableRow(
                      children: [TableCell(child: Text("Email")), Container()]),
                  TableRow(children: [
                    TableCell(child: Text("Abilitato")),
                    TableCell(child: Text("Cancellato"))
                  ]),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("Inserisci"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      elevation: 4,
    );
  }
}
