import 'package:flutter/material.dart';
import 'package:scadenziario/components/footer.dart';
import 'package:scadenziario/components/people_edit.dart';
import 'package:scadenziario/model/master_data.dart';
import 'package:scadenziario/repositories/masterdata_repository.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';

class PeopleScene extends StatefulWidget {
  final SqliteConnection _connection;

  const PeopleScene({super.key, required SqliteConnection connection})
      : _connection = connection;

  @override
  State<StatefulWidget> createState() => _PeopleSceneState();
}

enum SidebarType { none, newMasterData, editMasterdata }

class _PeopleSceneState extends State<PeopleScene> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  SidebarType _sidebarWidgetType = SidebarType.none;
  List<MasterData> _people = [];
  MasterData? _selectedPerson;

  @override
  void initState() {
    super.initState();
    _getAllMasterdata();
  }

  Future<void> _getAllMasterdata() async {
    var res = await MasterdataRepository(widget._connection).getAll();
    setState(() {
      _people = res;
    });
  }

  Widget _sidePanelBuilder() {
    switch (_sidebarWidgetType) {
      case SidebarType.newMasterData:
        {
          return Expanded(
              flex: 70,
              child: PeopleEdit(
                confirm: _personSaved,
                cancel: _editCancelled,
                connection: widget._connection,
              ));
        }
      default:
        {
          return Expanded(
            flex: 70,
            child: PeopleEdit(
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

    _getAllMasterdata();
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
                  children: _people
                      .map((p) => ListTile(
                            title: Text("${p.surname} ${p.name}"),
                            leading: const Icon(Icons.account_circle),
                            onTap: () {
                              setState(() {
                                _selectedPerson = p;
                                _sidebarWidgetType = SidebarType.editMasterdata;
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
              _sidebarWidgetType = SidebarType.newMasterData;
            });
          },
          tooltip: "Aggiungi persona",
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
