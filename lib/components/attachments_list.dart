import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:scadenziario/attachment_type.dart';
import 'package:scadenziario/model/attachment.dart';
import 'package:scadenziario/repositories/attachment_repository.dart';
import 'package:uuid/uuid.dart';

class AttachmentsList extends StatelessWidget {
  final AttachmentType _type;
  final List<Attachment> _attachments;
  final String _id;
  final Function() _reloadAttachments;

  const AttachmentsList({
    super.key,
    required AttachmentType type,
    required List<Attachment> attachments,
    required String id,
    required Function() reloadAttachments,
  })  : _type = type,
        _attachments = attachments,
        _id = id,
        _reloadAttachments = reloadAttachments;

  const AttachmentsList.person({
    super.key,
    required List<Attachment> attachments,
    required String id,
    required Function() reloadAttachments,
  })  : _id = id,
        _attachments = attachments,
        _type = AttachmentType.person,
        _reloadAttachments = reloadAttachments;

  const AttachmentsList.course({
    super.key,
    required List<Attachment> attachments,
    required String id,
    required Function() reloadAttachments,
  })  : _id = id,
        _attachments = attachments,
        _type = AttachmentType.course,
        _reloadAttachments = reloadAttachments;

  Future<bool> _download(BuildContext context, String id) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    Attachment? attachment = await AttachmentRepository().getById(id);
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
            child: const Text("Errore nel download del file'"),
          ),
        ),
      );
      return false;
    }

    String? selectedPath = await FilePicker.platform.getDirectoryPath(
      dialogTitle: "Selezionare la cartella dove salvare l'allegato",
    );
    if (selectedPath != null) {
      File f = File(
        selectedPath + Platform.pathSeparator + (attachment.fileName ?? ""),
      );

      if (await f.exists()) {
        if (context.mounted) {
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
                    child: const Text("No"),
                  ),
                  TextButton(
                    onPressed: () async {
                      await f.writeAsBytes(attachment.data!.toList());
                      navigator.pop();
                    },
                    child: const Text("Si"),
                  )
                ],
              );
            },
          );
        }
      } else {
        await f.writeAsBytes(attachment.data!.toList());
      }
    }
    return true;
  }

  _delete(BuildContext context, String id) async {
    final navigator = Navigator.of(context);
    await AttachmentRepository().delete(id, _type);
    navigator.pop();
    _reloadAttachments();
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
        const Uuid().v4(),
        f.path.split(Platform.pathSeparator).last,
        raw,
      );
      await AttachmentRepository().save(attachment, _id, _type);
    }
    _reloadAttachments();
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
              _attachments.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text("Nessun allegato presente"),
                    )
                  : ListView(
                      shrinkWrap: true,
                      children: _attachments
                          .map(
                            (a) => ListTile(
                              title: Text("${a.fileName}"),
                              leading: IconButton(
                                onPressed: () =>
                                    _download(context, a.id as String),
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
                                            onPressed: () => _delete(
                                                context, a.id as String),
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
