import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:scadenziario/components/attachments_list.dart';
import 'package:scadenziario/model/class.dart';
import 'package:scadenziario/repositories/attachment_repository.dart';
import 'package:scadenziario/repositories/class_repository.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';
import 'package:uuid/uuid.dart';

class CourseEdit extends StatefulWidget {
  final SqliteConnection _connection;
  final void Function() _confirm;
  final void Function() _cancel;
  final Class? _course;

  const CourseEdit(
      {super.key,
      required void Function() confirm,
      required void Function() cancel,
      Class? course,
      required SqliteConnection connection})
      : _confirm = confirm,
        _cancel = cancel,
        _course = course,
        _connection = connection;

  @override
  State<CourseEdit> createState() => _CourseEditState();
}

class _CourseEditState extends State<CourseEdit> {
  static final Logger log = Logger();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _id;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget._course != null) {
      _id = widget._course!.id;
      _nameController.text = widget._course?.name as String;
      _descriptionController.text = widget._course?.description ?? "";
      _durationController.text = widget._course?.duration.toString() ?? "";
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
                  child: Text(
                    widget._course == null ? "Nuovo corso" : "Modifica corso",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24),
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
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                            label: Text("Nome"), prefixIcon: Icon(Icons.title)),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => (value ?? "").isEmpty
                            ? "Il nome del corso è obbligatorio"
                            : null,
                      ),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            label: Text("Descrizione"),
                            prefixIcon: Icon(Icons.title)),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      TextFormField(
                        controller: _durationController,
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
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            Class activity = Class(
                                _id ?? const Uuid().v4().toString(),
                                _nameController.text,
                                _descriptionController.text,
                                int.parse(_durationController.text),
                                true,
                                false);

                            int res = await ClassRepository(widget._connection)
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
                        child: Text(
                            widget._course == null ? "Inserisci" : "Salva"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: widget._course != null,
          child: AttachmentsList(
            connection: widget._connection,
            type: AttachmentType.classAttachment,
            id: _id,
          ),
        ),
      ],
    );
  }
}
