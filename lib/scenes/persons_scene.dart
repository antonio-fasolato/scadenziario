import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scadenziario/attachment_type.dart';
import 'package:scadenziario/components/footer.dart';
import 'package:scadenziario/components/person_edit.dart';
import 'package:scadenziario/model/person.dart';
import 'package:scadenziario/repositories/attachment_repository.dart';
import 'package:scadenziario/repositories/person_repository.dart';
import 'package:scadenziario/services/csv_service.dart';
import 'package:scadenziario/state/person_state.dart';

class PersonsScene extends StatefulWidget {
  const PersonsScene({super.key});

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
      res = await PersonRepository.searchByName(_searchController.text);
    } else {
      res = await PersonRepository.getAll();
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
            ),
          )
        : Container();
  }

  Future<void> _selectPerson(Person p) async {
    final state = Provider.of<PersonState>(context, listen: false);

    state.selectPerson(p);
    state
        .setAttachments(await AttachmentRepository.getAttachmentsByLinkedEntity(
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

  _toCsv() async {
    List<List<dynamic>> data = [];
    data.add(Person.csvHeader);
    for (var p in _persons) {
      data.add(p.csvArray);
    }

    await CsvService.save(CsvService.toCsv(data));
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
                  child: Row(
                    children: [
                      Expanded(
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
                      IconButton(
                        onPressed: () async => await _toCsv(),
                        icon: const Icon(Icons.save),
                        tooltip: "Salva i nominativi come csv",
                      ),
                    ],
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
