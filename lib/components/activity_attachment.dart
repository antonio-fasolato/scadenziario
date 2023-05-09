import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:scadenziario/model/attachment.dart';
import 'package:scadenziario/repositories/attachment_repository.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';
import 'package:uuid/uuid.dart';

class ActivityAttachment extends StatefulWidget {
  final SqliteConnection _connection;
  final String? _id;

  const ActivityAttachment(
      {super.key, String? id, required SqliteConnection connection})
      : _id = id,
        _connection = connection;

  @override
  State<ActivityAttachment> createState() => _ActivityAttachmentState();
}

class _ActivityAttachmentState extends State<ActivityAttachment> {
  final Logger log = Logger();
  List<Attachment> _attachments = [];

  _loadAttachments() async {
    List<Attachment> res = [];
    if (widget._id != null) {
      res = await AttachmentRepository(widget._connection)
          .getClassAttachments(widget._id as String);
    }
    setState(() {
      _attachments = res;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadAttachments();
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
      log.d("Save file to $selectedPath");

      File f =
          File(selectedPath + Platform.pathSeparator + attachment.fileName);

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
    await AttachmentRepository(widget._connection).delete(id);
    await _loadAttachments();
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
          .save(attachment, widget._id as String);
      await _loadAttachments();
    }
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
            const Text("Allegati",
                style: TextStyle(fontWeight: FontWeight.bold)),
            ListView(
              shrinkWrap: true,
              children: _attachments
                  .map((a) => ListTile(
                        title: Text(a.fileName),
                        leading: IconButton(
                            onPressed: () {
                              _download(a.id);
                            },
                            icon: const Icon(Icons.download)),
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
                                          child: const Text("No")),
                                      TextButton(
                                          onPressed: () {
                                            _delete(a.id);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Si")),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.delete,
                                color: Colors.redAccent)),
                      ))
                  .toList(),
            ),
            ElevatedButton(
                onPressed: () => _addAttachment(),
                child: const Text("Aggiungi")),
          ],
        ),
      ),
    );
  }
}
