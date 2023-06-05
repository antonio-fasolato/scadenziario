import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scadenziario/components/footer.dart';
import 'package:scadenziario/components/person_edit.dart';
import 'package:scadenziario/model/person.dart';
import 'package:scadenziario/repositories/person_repository.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';
import 'package:scadenziario/state/person_state.dart';

class PersonsScene extends StatefulWidget {
  final SqliteConnection _connection;

  const PersonsScene({super.key, required SqliteConnection connection})
      : _connection = connection;

  @override
  State<StatefulWidget> createState() => _PersonsSceneState();
}

class _PersonsSceneState extends State<PersonsScene> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  List<Person> _persons = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getAllPersons();
  }

  Future<void> _getAllPersons() async {
    List<Person> res = [];
    if (_searchController.text.isNotEmpty) {
      res = await PersonRepository(widget._connection)
          .searchByName(_searchController.text);
    } else {
      res = await PersonRepository(widget._connection).getAll();
    }
    setState(() {
      _persons = res;
    });
  }

  Widget _sidePanelBuilder() {
    PersonState state = Provider.of<PersonState>(context, listen: false);
    return state.isSelected
        ? Expanded(
            flex: 70,
            child: PersonEdit(
              confirm: _personSaved,
              cancel: _editCancelled,
              connection: widget._connection,
            ),
          )
        : Container();
  }

  void _personSaved() {
    Provider.of<PersonState>(context, listen: false).deselectPerson();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Persona salvata correttamente"),
      ),
    );

    _getAllPersons();
  }

  void _editCancelled() {
    Provider.of<PersonState>(context, listen: false).deselectPerson();
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
                    onChanged: (value) => _getAllPersons(),
                  ),
                ),
                ListView(
                  shrinkWrap: true,
                  children: _persons
                      .map((p) => ListTile(
                            title: Text("${p.surname} ${p.name}"),
                            leading: const Icon(Icons.account_circle),
                            onTap: () {
                              Provider.of<PersonState>(context, listen: false)
                                  .selectPerson(p);
                            },
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          Consumer<PersonState>(
            builder: (context, state, child) => Visibility(
              visible: state.isSelected,
              child: _sidePanelBuilder(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const Footer(),
      floatingActionButton: Consumer<PersonState>(
        builder: (context, state, child) => Visibility(
          visible: !state.isSelected,
          child: FloatingActionButton(
            onPressed: () {
              state.selectPerson(Person.empty());
            },
            tooltip: "Aggiungi persona",
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
