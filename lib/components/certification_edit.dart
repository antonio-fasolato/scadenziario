import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';
import 'package:scadenziario/state/course_state.dart';

class CertificationEdit extends StatefulWidget {
  final SqliteConnection _connection;
  final void Function() _confirm;
  final void Function() _cancel;

  const CertificationEdit({
    super.key,
    required void Function() confirm,
    required void Function() cancel,
    required SqliteConnection connection,
  })  : _confirm = confirm,
        _cancel = cancel,
        _connection = connection;

  @override
  State<CertificationEdit> createState() => _CertificationEditState();
}

class _CertificationEditState extends State<CertificationEdit> {
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
                  child: Consumer<CourseState>(
                    builder: (context, state, child) => Text(
                      state.certification?.id == null
                          ? "Nuova certificazione per ${state.person.surname} ${state.person.name}"
                          : "Modifica certificazione di ${state.person.surname} ${state.person.name}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ),
                ),
                Flexible(
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 8, bottom: 8),
                            child: Text(
                              "Dati della certificazione",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      Consumer<CourseState>(
                        builder: (context, state, child) => Form(
                          key: state.certificationFormKey,
                          child: Column(
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller:
                                    state.certificationNoteController,
                                decoration: const InputDecoration(
                                    label: Text("Note"),
                                    prefixIcon: Icon(Icons.note)),
                                minLines: 1,
                                maxLines: 10,
                              ),
                              TextFormField(
                                controller:
                                    state.certificationIssuingController,
                                decoration: const InputDecoration(
                                    label: Text("Data certificato"),
                                    prefixIcon: Icon(Icons.calendar_month)),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) => (value ?? "").isEmpty
                                    ? "La data del certificato è obbligatoria"
                                    : null,
                                onTap: () async {
                                  DateTime? pickedDate =
                                      await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now().add(
                                              const Duration(days: 365)));
                                  if (pickedDate != null) {
                                    state.changeCertificationIssuingDate(
                                        DateFormat.yMd('it_IT')
                                            .format(pickedDate));
                                    state.changeCertificationExpirationDate(
                                        DateFormat.yMd('it_IT').format(
                                            pickedDate.add(Duration(
                                                days:
                                                    state.course.duration ??
                                                        0 * 30))));
                                  }
                                },
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 16.0),
                                child: Icon(Icons.arrow_downward_rounded),
                              ),
                              TextFormField(
                                controller:
                                    state.certificationExpirationController,
                                decoration: const InputDecoration(
                                    label: Text("Data scadenza"),
                                    prefixIcon: Icon(Icons.calendar_month)),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) => (value ?? "").isEmpty
                                    ? "La data di scadenza del certificato"
                                    : null,
                                onTap: () async {
                                  DateTime? pickedDate =
                                      await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now().add(
                                              const Duration(
                                                  days: 365 * 10)));
                                  if (pickedDate != null) {
                                    String formattedDate =
                                        DateFormat.yMd('it_IT')
                                            .format(pickedDate);
                                    state.changeCertificationExpirationDate(
                                        formattedDate);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: ElevatedButton(
                        onPressed: widget._cancel,
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
                          // CourseState state =
                          //     Provider.of<CourseState>(context, listen: false);
                          //
                          // if (state.certificationFormKey.currentState!
                          //         .validate() &&
                          //     _selectedPersons.isNotEmpty) {
                          //   for (var p in _selectedPersons) {
                          //     Certification cert = Certification(
                          //         const Uuid().v4().toString(),
                          //         state.course.id,
                          //         p,
                          //         state.certificationIssuingController.text,
                          //         state.certificationExpirationController.text,
                          //         state.certificationNoteController.text);
                          //
                          //     await CertificationRepository(widget._connection)
                          //         .save(cert);
                          //   }
                          //
                          //   widget._confirm();
                          // }
                        },
                        child: Consumer<CourseState>(
                          builder: (context, state, child) => Text(
                              state.course.id == null ? "Inserisci" : "Salva"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
