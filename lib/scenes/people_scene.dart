import 'package:flutter/material.dart';
import 'package:scadenziario/components/footer.dart';

class PeopleScene extends StatefulWidget {
  const PeopleScene({super.key});

  @override
  State<StatefulWidget> createState() => _PeopleSceneState();
}

enum SidebarType { none, newMasterData, editMasterdata }

class _PeopleSceneState extends State<PeopleScene> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  SidebarType _sidebarWidgetType = SidebarType.none;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scadenziario - Personale"),
      ),
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                        label: Text("Cerca"), prefixIcon: Icon(Icons.search)),
                  ),
                ),
                ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      title: const Text("Mario Rossi"),
                      leading: const Icon(Icons.account_circle),
                      onTap: () {
                        setState(() {
                          _sidebarWidgetType = SidebarType.editMasterdata;
                        });
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
          Visibility(
            visible: _sidebarWidgetType != SidebarType.none,
            child: Expanded(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _sidebarWidgetType = SidebarType.none;
                      });
                    },
                    child: const Text("Chiudi"),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const Footer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _sidebarWidgetType = SidebarType.newMasterData;
          });
        },
        tooltip: "Aggiungi personale",
        child: const Icon(Icons.add),
      ),
    );
  }
}
