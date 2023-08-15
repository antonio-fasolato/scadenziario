import 'package:flutter/material.dart';
import 'package:scadenziario/model/duty.dart';
import 'package:scadenziario/repositories/duty_repository.dart';
import 'package:uuid/uuid.dart';

class SettingsRoles extends StatefulWidget {
  const SettingsRoles({super.key});

  @override
  State<SettingsRoles> createState() => _SettingsRolesState();
}

class _SettingsRolesState extends State<SettingsRoles> {
  List<Duty> _duties = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _newDutyController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _loadDuties();
  }

  @override
  void dispose() {
    _newDutyController.dispose();

    super.dispose();
  }

  _loadDuties() async {
    var duties = await DutyRepository.getAllDuties();
    setState(() {
      _duties = duties;
    });
  }

  _addDuty() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (_formKey.currentState?.validate() ?? false) {
      int res = await DutyRepository.save(Duty(
        const Uuid().v4().toString(),
        _newDutyController.text,
      ));
      if (res == 0) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Container(
              padding: const EdgeInsets.all(16),
              height: 90,
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: const Text("Errore nel salvataggio del ruolo"),
            ),
          ),
        );
      }
    }
  }

  _deleteDuty(Duty d) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    Navigator.of(context).pop();

    if ((await DutyRepository.getPersonsFromDuty(d)).isNotEmpty) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Container(
            padding: const EdgeInsets.all(16),
            height: 90,
            decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Text(
                "Il ruolo ${d.description} è associato almeno ad un'anagrafica e non può essere cancellato"),
          ),
        ),
      );
      return;
    }

    await DutyRepository.delete(d);
    await _loadDuties();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text(
            "Ruoli anagrafiche",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          ListView(
            shrinkWrap: true,
            children: _duties
                .map(
                  (d) => ListTile(
                    title: Text("${d.description}"),
                    subtitle: Text("${d.id}"),
                    trailing: IconButton(
                      onPressed: () async => showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                                "Confermare la cancellazione del ruolo ${d.description}?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("No"),
                              ),
                              TextButton(
                                onPressed: () async => await _deleteDuty(d),
                                child: const Text("Si"),
                              ),
                            ],
                          );
                        },
                      ),
                      icon: const Icon(Icons.delete),
                      color: Colors.redAccent,
                    ),
                  ),
                )
                .toList(),
          ),
          Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _newDutyController,
                    decoration: InputDecoration(
                      label: const Text("Nuovo ruolo"),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          await _addDuty();
                          _newDutyController.clear();
                          await _loadDuties();
                        },
                        icon: const Icon(Icons.keyboard_return),
                      ),
                    ),
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if ((value ?? "").isEmpty) {
                        return "La descrizione del ruolo è obbligatoria";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
