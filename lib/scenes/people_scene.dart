import 'package:flutter/material.dart';
import 'package:scadenziario/components/footer.dart';

class PeopleScene extends StatelessWidget {
  PeopleScene({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scadenziario - Personale"),
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
                  title: Text("Mario Rossi"),
                  leading: Icon(Icons.account_circle),
                )
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Footer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: "Aggiungi personale",
        child: const Icon(Icons.add),
      ),
    );
  }
}
