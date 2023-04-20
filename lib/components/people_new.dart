import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:scadenziario/model/duty.dart';
import 'package:scadenziario/model/master_data.dart';
import 'package:scadenziario/repositories/duty_repository.dart';
import 'package:scadenziario/repositories/masterdata_repository.dart';
import 'package:uuid/uuid.dart';

class PeopleNew extends StatefulWidget {
  final void Function() _confirm;

  const PeopleNew({super.key, required void Function() confirm})
      : _confirm = confirm;

  @override
  State<PeopleNew> createState() => _PeopleNewState();
}

class _PeopleNewState extends State<PeopleNew> {
  static final Logger log = Logger();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _dutyController = TextEditingController();
  List<Duty> _duties = [];

  @override
  void initState() {
    super.initState();

    _loadDuties();
  }

  Future<void> _loadDuties() async {
    var duties = await DutyRepository.getAllDuties();

    setState(() {
      _duties = duties;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Text("Nuova persona",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: Text("Dati anagrafici",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Form(
              key: _formKey,
              child: Table(
                children: [
                  TableRow(children: [
                    TableCell(
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                            label: Text("Nome"),
                            prefixIcon: Icon(Icons.person)),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => (value ?? "").isEmpty
                            ? "Il nome della persona è obbligatorio"
                            : null,
                      ),
                    ),
                    TableCell(
                      child: TextFormField(
                        controller: _surnameController,
                        decoration: const InputDecoration(
                            label: Text("Cognome"),
                            prefixIcon: Icon(Icons.person)),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => (value ?? "").isEmpty
                            ? "Il cognome della persona è obbligatorio"
                            : null,
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: TextFormField(
                      controller: _birthDateController,
                      decoration: const InputDecoration(
                          label: Text("Data di nascita"),
                          prefixIcon: Icon(Icons.calendar_today)),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now());
                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat.yMd('it_IT').format(pickedDate);
                          setState(() {
                            _birthDateController.text = formattedDate;
                          });
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => (value ?? "").isEmpty
                          ? "La data di nascita è obbligatoria"
                          : null,
                    )),
                    TableCell(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                            label: Text("Mansione"),
                            prefixIcon: Icon(Icons.work)),
                        items: _duties
                            .map<DropdownMenuItem<String>>((d) =>
                                DropdownMenuItem<String>(
                                    value: d.id,
                                    child: Text(d.description ?? "")))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _dutyController.text = value ?? "";
                          });
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => (value ?? "").isEmpty
                            ? "La mansione della persona è obbligatoria"
                            : null,
                      ),
                    )
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: TextFormField(
                      controller: _mailController,
                      decoration: const InputDecoration(
                          label: Text("Email"), prefixIcon: Icon(Icons.mail)),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if ((value ?? "").isEmpty) {
                          return "L'indirizzo email è obbligatorio";
                        }
                        if (!EmailValidator.validate(value ?? "")) {
                          return "L'indirizzo mail non è corretto";
                        }
                        return null;
                      },
                    )),
                    Container()
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                          label: Text("Telefono"),
                          prefixIcon: Icon(Icons.phone)),
                    )),
                    TableCell(
                        child: TextFormField(
                      controller: _mobileController,
                      decoration: const InputDecoration(
                          label: Text("Cellulare"),
                          prefixIcon: Icon(Icons.phone_android)),
                    ))
                  ]),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        MasterData person = MasterData(
                            const Uuid().v4().toString(),
                            _nameController.text,
                            _surnameController.text,
                            DateFormat.yMd('it_IT')
                                .parse(_birthDateController.text),
                            _mailController.text,
                            _phoneController.text,
                            _mobileController.text,
                            true,
                            false);
                        int res = await MasterdataRepository.save(person);
                        if (res == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Container(
                                  padding: const EdgeInsets.all(16),
                                  height: 90,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: const Text(
                                      "Errore nel salvataggio della persona")),
                            ),
                          );
                        } else {
                          widget._confirm();
                        }
                      }
                    },
                    child: const Text("Inserisci"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
