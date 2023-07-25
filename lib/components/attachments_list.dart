import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:scadenziario/model/attachment.dart';
import 'package:scadenziario/repositories/attachment_repository.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';
import 'package:uuid/uuid.dart';

class AttachmentsList extends StatefulWidget {
  final SqliteConnection _connection;
  final AttachmentType _type;
  final List<Attachment> _attachments;
  final String _id;
  final Function() _reloadAttachments;

  const AttachmentsList({
    super.key,
    required AttachmentType type,
    required List<Attachment> attachments,
    required String id,
    required SqliteConnection connection,
    required Function() reloadAttachments,
  })  : _type = type,
        _attachments = attachments,
        _id = id,
        _connection = connection,
        _reloadAttachments = reloadAttachments;

  const AttachmentsList.person({
    super.key,
    required List<Attachment> attachments,
    required String id,
    required SqliteConnection connection,
    required Function() reloadAttachments,
  })  : _id = id,
        _attachments = attachments,
        _type = AttachmentType.person,
        _connection = connection,
        _reloadAttachments = reloadAttachments;

  const AttachmentsList.course({
    super.key,
    required List<Attachment> attachments,
    required String id,
    required SqliteConnection connection,
    required Function() reloadAttachments,
  })  : _id = id,
        _attachments = attachments,
        _type = AttachmentType.course,
        _connection = connection,
        _reloadAttachments = reloadAttachments;

  @override
  State<AttachmentsList> createState() => _AttachmentsListState();
}

class _AttachmentsListState extends State<AttachmentsList> {
  final log = Logger((AttachmentsList).toString());

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _download(String id) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    Attachment? attachment =
        await AttachmentRepository(widget._connection).getById(id);
    if (attachment == null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Container(
              padding: const EdgeInsets.all(16),
              height: 90,
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: const Text("Errore nel download del file'")),
        ),
      );
      return false;
    }

    String? selectedPath = await FilePicker.platform.getDirectoryPath(
      dialogTitle: "Selezionare la cartella dove salvare l'allegato",
    );
    if (selectedPath != null) {
      log.info("Save file to $selectedPath");

      File f = File(
          selectedPath + Platform.pathSeparator + (attachment.fileName ?? ""));

      if (await f.exists()) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Il file esiste già, sovrascrivere."),
              actions: [
                TextButton(
                    onPressed: () {
                      navigator.pop();
                    },
                    child: const Text("No")),
                TextButton(
                    onPressed: () async {
                      await f.writeAsBytes(attachment.data!.toList());
                      navigator.pop();
                    },
                    child: const Text("Si"))
              ],
            );
          },
        );
      } else {
        await f.writeAsBytes(attachment.data!.toList());
      }
    }
    return true;
  }

  _delete(String id) async {
    final navigator = Navigator.of(context);
    await AttachmentRepository(widget._connection).delete(id, widget._type);
    navigator.pop();
    widget._reloadAttachments();
  }

  _addAttachment() async {
    FilePickerResult? res = await FilePicker.platform.pickFiles(
      dialogTitle: "Selezionare il file da allegare",
      allowMultiple: false,
    );
    if (res != null && res.count > 0 && res.paths.first != null) {
      String path = res.paths.first as String;
      File f = File(path);
      Uint8List raw = await f.readAsBytes();
      Attachment attachment = Attachment(
          const Uuid().v4(), f.path.split(Platform.pathSeparator).last, raw);
      await AttachmentRepository(widget._connection)
          .save(attachment, widget._id as String, widget._type);
    }
    widget._reloadAttachments();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          elevation: 4,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  "Allegati",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              ListView(
                shrinkWrap: true,
                children: widget._attachments
                    .map(
                      (a) => ListTile(
                        title: Text("${a.fileName}"),
                        leading: IconButton(
                          onPressed: () => _download(a.id as String),
                          icon: const Icon(Icons.attachment_outlined),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                      "Confermare la cancellazione del file ${a.fileName}?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text("No"),
                                    ),
                                    TextButton(
                                      onPressed: () => _delete(a.id as String),
                                      child: const Text("Si"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: () => _addAttachment(),
                      icon: const Icon(Icons.attachment_outlined),
                      label: const Text("Aggungi"),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
