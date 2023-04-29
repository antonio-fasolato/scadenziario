import 'package:flutter/material.dart';
import 'package:scadenziario/components/footer.dart';

class ActivitiesScene extends StatefulWidget {
  ActivitiesScene({super.key});

  @override
  State<ActivitiesScene> createState() => _ActivitiesSceneState();
}

class _ActivitiesSceneState extends State<ActivitiesScene> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scadenziario - Attività e corsi"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Form(
                key: _formKey,
                child: TextFormField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                      label: Text("Cerca"), prefixIcon: Icon(Icons.search)),
                )),
            ListView(
              shrinkWrap: true,
              children: const [
                ListTile(
                  title: Text("Corso di primo soccorso"),
                  subtitle: Text("Scadenza 01/01/2023 - Iscritti 25"),
                  leading: Icon(Icons.business_center),
                )
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Footer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: "Aggiungi Attività/corso",
        child: const Icon(Icons.add),
      ),
    );
  }
}
