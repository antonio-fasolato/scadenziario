import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scadenziario/attachment_type.dart';
import 'package:scadenziario/components/footer.dart';
import 'package:scadenziario/components/person_edit.dart';
import 'package:scadenziario/model/person.dart';
import 'package:scadenziario/repositories/attachment_repository.dart';
import 'package:scadenziario/repositories/person_repository.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';
import 'package:scadenziario/services/csv_service.dart';
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

  Future<void> _selectPerson(Person p) async {
    final state = Provider.of<PersonState>(context, listen: false);

    state.selectPerson(p);
    state.setAttachments(await AttachmentRepository(widget._connection)
        .getAttachmentsByLinkedEntity(
      p.id as String,
      AttachmentType.person,
    ));
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

  _toCsv() {
    List<List<dynamic>> data = [];
    data.add(Person.csvHeader);
    for (var p in _persons) {
      data.add(p.csvArray);
    }

    CsvService().toCsv(data);
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
                    decoration: InputDecoration(
                        label: const Text("Cerca"),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _getAllPersons();
                          },
                          icon: const Icon(Icons.backspace),
                        )),
                    onChanged: (value) => _getAllPersons(),
                  ),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: _persons
                        .map((p) => ListTile(
                              title: Text("${p.surname} ${p.name}"),
                              leading: const Icon(Icons.account_circle),
                              onTap: () => _selectPerson(p),
                            ))
                        .toList(),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _toCsv(),
                  icon: const Icon(Icons.save_alt_outlined),
                  label: const Text("CSV"),
                )
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
