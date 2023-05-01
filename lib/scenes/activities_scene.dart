import 'package:flutter/material.dart';
import 'package:scadenziario/components/footer.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';

class ActivitiesScene extends StatefulWidget {
  final SqliteConnection _connection;

  const ActivitiesScene({super.key, required SqliteConnection connection})
      : _connection = connection;

  @override
  State<ActivitiesScene> createState() => _ActivitiesSceneState();
}

enum SidebarType { none, newActivity, editActivity }

class _ActivitiesSceneState extends State<ActivitiesScene> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  SidebarType _sidebarWidgetType = SidebarType.none;

  Widget _sidePanelBuilder() {
    switch (_sidebarWidgetType) {
      case SidebarType.newActivity:
        {
          return Expanded(flex: 70, child: Text("Nuova attività"));
        }
      default:
        {
          return Expanded(flex: 70, child: Text("Modifica attività"));
        }
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scadenziario - Attività e corsi"),
      ),
      body: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 30,
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
                  children: [
                    ListTile(
                      title: const Text("Corso di primo soccorso"),
                      subtitle: const Text("Scadenza 01/01/2023 - Iscritti 25"),
                      leading: const Icon(Icons.business_center),
                      onTap: () {
                        setState(() {
                          _sidebarWidgetType = SidebarType.editActivity;
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
              child: _sidePanelBuilder())
        ],
      ),
      bottomNavigationBar: const Footer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _sidebarWidgetType = SidebarType.newActivity;
          });
        },
        tooltip: "Aggiungi Attività/corso",
        child: const Icon(Icons.add),
      ),
    );
  }
}
