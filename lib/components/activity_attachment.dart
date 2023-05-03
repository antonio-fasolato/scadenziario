import 'package:flutter/material.dart';
import 'package:scadenziario/model/attachment.dart';
import 'package:scadenziario/repositories/attachmentRepository.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';

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
                        leading: const Icon(Icons.download),
                        trailing:
                            const Icon(Icons.delete, color: Colors.redAccent),
                      ))
                  .toList(),
            ),
            ElevatedButton(onPressed: () {}, child: const Text("Aggiungi"))
          ],
        ),
      ),
    );
  }
}
