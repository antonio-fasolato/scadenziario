import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:scadenziario/components/attachments_list.dart';
import 'package:scadenziario/model/duty.dart';
import 'package:scadenziario/model/master_data.dart';
import 'package:scadenziario/repositories/attachment_repository.dart';
import 'package:scadenziario/repositories/duty_repository.dart';
import 'package:scadenziario/repositories/person_repository.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';
import 'package:uuid/uuid.dart';

class PersonEdit extends StatefulWidget {
  final SqliteConnection _connection;
  final void Function() _confirm;
  final void Function() _cancel;
  final MasterData? _person;

  const PersonEdit(
      {super.key,
      required void Function() confirm,
      required void Function() cancel,
      MasterData? person,
      required SqliteConnection connection})
      : _confirm = confirm,
        _cancel = cancel,
        _person = person,
        _connection = connection;

  @override
  State<PersonEdit> createState() => _PersonEditState();
}

class _PersonEditState extends State<PersonEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _id;
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

    if (widget._person != null) {
      _id = widget._person!.id;
      _nameController.text = widget._person!.name as String;
      _surnameController.text = widget._person!.surname as String;
      _birthDateController.text =
          DateFormat.yMd('it_IT').format(widget._person!.birthdate as DateTime);
      _dutyController.text = widget._person!.duty as String;
      _mailController.text = widget._person!.email as String;
      _phoneController.text = widget._person!.phone ?? "";
      _mobileController.text = widget._person!.mobile ?? "";
    }
    _loadDuties();
  }

  Future<void> _loadDuties() async {
    var duties = await DutyRepository(widget._connection).getAllDuties();

    setState(() {
      _duties = duties;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Text(
                      widget._person != null
                          ? "Modifica dati persona"
                          : "Nuova persona",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24)),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                            value: _dutyController.text.isEmpty
                                ? null
                                : _dutyController.text,
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                              label: Text("Email"),
                              prefixIcon: Icon(Icons.mail)),
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
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9 \-]'))
                          ],
                          decoration: const InputDecoration(
                              label: Text("Telefono"),
                              prefixIcon: Icon(Icons.phone)),
                        )),
                        TableCell(
                            child: TextFormField(
                          controller: _mobileController,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9 \-]'))
                          ],
                          decoration: const InputDecoration(
                              label: Text("Cellulare"),
                              prefixIcon: Icon(Icons.phone_android)),
                        ))
                      ]),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: ElevatedButton(
                        onPressed: () {
                          widget._cancel();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent),
                        child: const Text("Annulla"),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            MasterData person = MasterData(
                                _id ?? const Uuid().v4().toString(),
                                _nameController.text,
                                _surnameController.text,
                                DateFormat.yMd('it_IT')
                                    .parse(_birthDateController.text),
                                _dutyController.text,
                                _mailController.text,
                                _phoneController.text,
                                _mobileController.text,
                                true,
                                false);
                            int res =
                                await PersonRepository(widget._connection)
                                    .save(person);
                            if (res == 0) {
                              if (!context.mounted) {
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Container(
                                      padding: const EdgeInsets.all(16),
                                      height: 90,
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
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
                        child: Text(
                            widget._person == null ? "Inserisci" : "Salva"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: widget._person != null,
          child: AttachmentsList(
            connection: widget._connection,
            type: AttachmentType.masterdata,
            id: _id,
          ),
        ),
      ],
    );
  }
}
