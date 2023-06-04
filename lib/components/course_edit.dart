import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scadenziario/components/attachments_list.dart';
import 'package:scadenziario/model/course.dart';
import 'package:scadenziario/repositories/attachment_repository.dart';
import 'package:scadenziario/repositories/course_repository.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';
import 'package:scadenziario/state/course_state.dart';
import 'package:uuid/uuid.dart';

class CourseEdit extends StatefulWidget {
  final SqliteConnection _connection;
  final void Function() _confirm;
  final void Function() _cancel;

  const CourseEdit(
      {super.key,
      required void Function() confirm,
      required void Function() cancel,
      required SqliteConnection connection})
      : _confirm = confirm,
        _cancel = cancel,
        _connection = connection;

  @override
  State<CourseEdit> createState() => _CourseEditState();
}

class _CourseEditState extends State<CourseEdit> {
  _attachmentsPopup(BuildContext context) {
    CourseState state = Provider.of<CourseState>(context, listen: false);

    if (state.isSelected) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                const Text("Allegati"),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(Icons.close),
                )
              ],
            ),
            content: AttachmentsList.course(
              connection: widget._connection,
              id: state.course.id as String,
            ),
          );
        },
      );
    } else {
      return Container();
    }
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
                  child: Consumer<CourseState>(
                    builder: (context, state, child) => Text(
                      state.course.id == null
                          ? "Nuovo corso"
                          : "Modifica corso",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: Text(
                        "Dati del corso",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                Consumer<CourseState>(
                  builder: (context, state, child) => Form(
                    key: state.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: state.nameController,
                          decoration: const InputDecoration(
                              label: Text("Nome"),
                              prefixIcon: Icon(Icons.title)),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => (value ?? "").isEmpty
                              ? "Il nome del corso è obbligatorio"
                              : null,
                        ),
                        TextFormField(
                          controller: state.descriptionController,
                          decoration: const InputDecoration(
                              label: Text("Descrizione"),
                              prefixIcon: Icon(Icons.title)),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        TextFormField(
                          controller: state.durationController,
                          decoration: const InputDecoration(
                              label: Text("Durata"),
                              prefixIcon: Icon(Icons.timer)),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => (value ?? "").isEmpty
                              ? "La durata del corso è obbligatoria"
                              : null,
                        ),
                      ],
                    ),
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
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: ElevatedButton.icon(
                        onPressed: () => _attachmentsPopup(context),
                        icon: const Icon(Icons.attachment_outlined),
                        label: const Text("Allegati"),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, top: 16, bottom: 8),
                      child: ElevatedButton(
                        onPressed: () async {
                          CourseState state =
                              Provider.of<CourseState>(context, listen: false);

                          if (state.formKey.currentState!.validate()) {
                            Course activity = Course(
                                state.course.id ?? const Uuid().v4().toString(),
                                state.nameController.text,
                                state.descriptionController.text,
                                int.parse(state.durationController.text),
                                true,
                                false);

                            int res = await CourseRepository(widget._connection)
                                .save(activity);
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
                                          "Errore nel salvataggio del corso")),
                                ),
                              );
                            } else {
                              widget._confirm();
                            }
                          }
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
        // Visibility(
        //   visible: widget._course != null,
        //   child: AttachmentsList(
        //     connection: widget._connection,
        //     type: AttachmentType.course,
        //     id: _id,
        //   ),
        // ),
      ],
    );
  }
}
