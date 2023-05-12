import 'package:flutter/material.dart';
import 'package:scadenziario/components/footer.dart';
import 'package:scadenziario/components/person_edit.dart';
import 'package:scadenziario/model/master_data.dart';
import 'package:scadenziario/repositories/person_repository.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';

class PersonsScene extends StatefulWidget {
  final SqliteConnection _connection;

  const PersonsScene({super.key, required SqliteConnection connection})
      : _connection = connection;

  @override
  State<StatefulWidget> createState() => _PersonsSceneState();
}

enum SidebarType { none, newPerson, editPerson }

class _PersonsSceneState extends State<PersonsScene> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  SidebarType _sidebarWidgetType = SidebarType.none;
  List<MasterData> _persons = [];
  MasterData? _selectedPerson;

  @override
  void initState() {
    super.initState();
    _getAllPersons();
  }

  Future<void> _getAllPersons() async {
    var res = await MasterdataRepository(widget._connection).getAll();
    setState(() {
      _persons = res;
    });
  }

  Widget _sidePanelBuilder() {
    switch (_sidebarWidgetType) {
      case SidebarType.newPerson:
        {
          return Expanded(
              flex: 70,
              child: PersonEdit(
                confirm: _personSaved,
                cancel: _editCancelled,
                connection: widget._connection,
              ));
        }
      default:
        {
          return Expanded(
            flex: 70,
            child: PersonEdit(
              confirm: _personSaved,
              cancel: _editCancelled,
              person: _selectedPerson,
              connection: widget._connection,
            ),
          );
        }
    }
  }

  void _personSaved() {
    setState(() {
      _sidebarWidgetType = SidebarType.none;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Persona salvata correttamente"),
      ),
    );

    _getAllPersons();
  }

  void _editCancelled() {
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
                  children: _persons
                      .map((p) => ListTile(
                            title: Text("${p.surname} ${p.name}"),
                            leading: const Icon(Icons.account_circle),
                            onTap: () {
                              setState(() {
                                _selectedPerson = p;
                                _sidebarWidgetType = SidebarType.editPerson;
                              });
                            },
                          ))
                      .toList(),
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
              _sidebarWidgetType = SidebarType.newPerson;
            });
          },
          tooltip: "Aggiungi persona",
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
