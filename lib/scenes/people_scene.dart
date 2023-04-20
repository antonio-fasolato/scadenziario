import 'package:flutter/material.dart';
import 'package:scadenziario/components/footer.dart';
import 'package:scadenziario/components/people_edit.dart';
import 'package:scadenziario/components/people_new.dart';

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

  Widget _sidePanelBuilder() {
    switch (_sidebarWidgetType) {
      case SidebarType.newMasterData:
        {
          return Expanded(
              flex: 70,
              child: PeopleNew(
                confirm: _closeSidePanel,
              ));
        }
      default:
        {
          return Expanded(
            flex: 70,
            child: PeopleEdit(),
          );
        }
    }
  }

  void _closeSidePanel() {
    setState(() {
      _sidebarWidgetType = SidebarType.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scadenziario - Personale"),
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
            child: _sidePanelBuilder(),
          ),
        ],
      ),
      bottomNavigationBar: const Footer(),
      floatingActionButton: Visibility(
        visible: _sidebarWidgetType == SidebarType.none,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              _sidebarWidgetType = SidebarType.newMasterData;
            });
          },
          tooltip: "Aggiungi personale",
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
