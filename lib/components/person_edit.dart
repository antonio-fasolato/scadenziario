import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scadenziario/attachment_type.dart';
import 'package:scadenziario/components/attachments_list.dart';
import 'package:scadenziario/components/person_certifications_list.dart';
import 'package:scadenziario/model/person.dart';
import 'package:scadenziario/repositories/attachment_repository.dart';
import 'package:scadenziario/repositories/duty_repository.dart';
import 'package:scadenziario/repositories/person_repository.dart';
import 'package:scadenziario/state/person_state.dart';
import 'package:uuid/uuid.dart';

class PersonEdit extends StatefulWidget {
  final void Function() _confirm;
  final void Function() _cancel;

  const PersonEdit({
    super.key,
    required void Function() confirm,
    required void Function() cancel,
  })  : _confirm = confirm,
        _cancel = cancel;

  @override
  State<PersonEdit> createState() => _PersonEditState();
}

class _PersonEditState extends State<PersonEdit> {
  @override
  void initState() {
    super.initState();

    _loadDuties();
  }

  Future<void> _loadDuties() async {
    PersonState state = Provider.of<PersonState>(context, listen: false);
    var duties = await DutyRepository.getAllDuties();
    state.loadDuties(duties);
  }

  Future<void> _loadAttachments() async {
    PersonState state = Provider.of<PersonState>(context, listen: false);

    if (state.isSelected) {
      var attachments = await AttachmentRepository.getAttachmentsByLinkedEntity(
        state.person.id as String,
        AttachmentType.person,
      );

      state.setAttachments(attachments);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
                    child: Consumer<PersonState>(
                      builder: (context, state, child) => Text(
                        state.person.id != null
                            ? "Modifica dati persona"
                            : "Nuova persona",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
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
                  Consumer<PersonState>(
                    builder: (context, state, child) => Form(
                      key: state.formKey,
                      child: Table(
                        children: [
                          TableRow(children: [
                            TableCell(
                              child: TextFormField(
                                controller: state.nameController,
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
                                controller: state.surnameController,
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
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: TextFormField(
                                  controller: state.birthDateController,
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
                                          DateFormat.yMd('it_IT')
                                              .format(pickedDate);
                                      state
                                          .changePersonBirthdate(formattedDate);
                                    }
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) => (value ?? "").isEmpty
                                      ? "La data di nascita è obbligatoria"
                                      : null,
                                ),
                              ),
                            ),
                            TableCell(
                              child: DropdownButtonFormField<String>(
                                value: state.dutyController.text.isEmpty
                                    ? null
                                    : state.dutyController.text,
                                decoration: const InputDecoration(
                                    label: Text("Mansione"),
                                    prefixIcon: Icon(Icons.work)),
                                items: state.duties
                                    .map<DropdownMenuItem<String>>((d) =>
                                        DropdownMenuItem<String>(
                                            value: d.id,
                                            child: Text(d.description ?? "")))
                                    .toList(),
                                onChanged: (value) =>
                                    state.changePersonDuty(value ?? ""),
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
                              controller: state.mailController,
                              decoration: const InputDecoration(
                                  label: Text("Email"),
                                  prefixIcon: Icon(Icons.mail)),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                              controller: state.phoneController,
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
                              controller: state.mobileController,
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
                        padding:
                            const EdgeInsets.only(left: 16, top: 16, bottom: 8),
                        child: ElevatedButton(
                          onPressed: () async {
                            final scaffoldMessenger =
                                ScaffoldMessenger.of(context);

                            PersonState state = Provider.of<PersonState>(
                                context,
                                listen: false);
                            if (state.formKey.currentState?.validate() ??
                                false) {
                              Person person = Person(
                                  state.person.id ??
                                      const Uuid().v4().toString(),
                                  state.nameController.text,
                                  state.surnameController.text,
                                  DateFormat.yMd('it_IT')
                                      .parse(state.birthDateController.text),
                                  state.dutyController.text,
                                  state.mailController.text,
                                  state.phoneController.text,
                                  state.mobileController.text,
                                  true,
                                  false);
                              int res = await PersonRepository.save(person);
                              if (res == 0) {
                                scaffoldMessenger.showSnackBar(
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
                          child: Consumer<PersonState>(
                            builder: (context, state, child) => Text(
                                state.person.id == null
                                    ? "Inserisci"
                                    : "Salva"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Consumer<PersonState>(
                  builder: (context, state, child) => Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: AttachmentsList(
                      type: AttachmentType.person,
                      attachments: state.attachments,
                      id: state.person.id,
                      reloadAttachments: _loadAttachments,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Consumer<PersonState>(
                  builder: (context, state, child) => Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: PersonCertificationsList(
                      person: state.person,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
