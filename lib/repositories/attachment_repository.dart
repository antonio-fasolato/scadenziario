import 'package:logger/logger.dart';
import 'package:scadenziario/model/attachment.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';

enum AttachmentType { masterdata, classAttachment }

class AttachmentRepository {
  static final Logger log = Logger();
  final SqliteConnection _connection;

  AttachmentRepository(SqliteConnection connection) : _connection = connection;

  Future<List<Attachment>> getClassAttachments(String id) async {
    var db = await _connection.connect();
    List<Attachment> toReturn = [];
    String sql = """
      select id, filename
      from attachment
      inner join class_attachment on
        attachment_id = id
      where 1 = 1
        and class_id = ?
      ORDER BY fileName
    """;
    var res = await db.rawQuery(sql, [id]);
    if (res.isNotEmpty) {
      toReturn = List.from(res.map((e) => Attachment.fromMap(e)));
    }

    await db.close();
    return toReturn;
  }

  Future<Attachment?> getById(String id) async {
    var db = await _connection.connect();
    Attachment? toReturn;

    var res = await db.query("attachment", where: "id = ?", whereArgs: [id]);
    if (res.isNotEmpty) {
      toReturn = Attachment.fromMap(res.first);
    }

    await db.close();
    return toReturn;
  }

  delete(String id) async {
    var db = await _connection.connect();

    await db.delete("class_attachment",
        where: "attachment_id = ?", whereArgs: [id]);
    await db.delete("attachment", where: "id = ?", whereArgs: [id]);

    await db.close();
  }

  save(Attachment a, String linkedId, AttachmentType type) async {
    var db = await _connection.connect();

    await db.insert("attachment", a.toMap());
    switch (type) {
      case AttachmentType.masterdata:
        break;
      case AttachmentType.classAttachment:
        await db.insert(
            "class_attachment", {"attachment_id": a.id, "class_id": linkedId});
        break;
    }

    await db.close();
  }
}
