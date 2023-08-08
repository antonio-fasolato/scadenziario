import 'package:scadenziario/attachment_type.dart';
import 'package:scadenziario/model/attachment.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';

class AttachmentRepository {
  static Future<List<Attachment>> getAttachmentsByLinkedEntity(
      String id, AttachmentType type) async {
    var db = SqliteConnection().db;
    List<Attachment> toReturn = [];
    String joinTable = "";
    String foreignKey = "";
    switch (type) {
      case AttachmentType.course:
        joinTable = "course_attachment";
        foreignKey = "course_id";
        break;
      case AttachmentType.person:
        joinTable = "person_attachment";
        foreignKey = "person_id";
        break;
    }
    String sql = """
      select id, filename
      from attachment
      inner join $joinTable on
        attachment_id = id
      where 1 = 1
        and $foreignKey = ?
      ORDER BY fileName
    """;
    var res = await db.rawQuery(sql, [id]);
    if (res.isNotEmpty) {
      toReturn = List.from(res.map((e) => Attachment.fromMap(e)));
    }

    return toReturn;
  }

  static Future<Attachment?> getById(String id) async {
    var db = SqliteConnection().db;
    Attachment? toReturn;

    var res = await db.query("attachment", where: "id = ?", whereArgs: [id]);
    if (res.isNotEmpty) {
      toReturn = Attachment.fromMap(res.first);
    }

    return toReturn;
  }

  static delete(String id, AttachmentType type) async {
    var db = SqliteConnection().db;

    switch (type) {
      case AttachmentType.course:
        await db.delete("course_attachment",
            where: "attachment_id = ?", whereArgs: [id]);
        break;
      case AttachmentType.person:
        await db.delete("person_attachment",
            where: "attachment_id = ?", whereArgs: [id]);
        break;
      case AttachmentType.certification:
        await db.update(
          "certification",
          {"attachment_id": null},
          where: "attachment_id = ?",
          whereArgs: [id],
        );
        break;
    }
    await db.delete("attachment", where: "id = ?", whereArgs: [id]);
  }

  static save(Attachment a, String linkedId, AttachmentType type) async {
    var db = SqliteConnection().db;

    await db.insert("attachment", a.toMap());
    switch (type) {
      case AttachmentType.person:
        await db.insert(
          "person_attachment",
          {"attachment_id": a.id, "person_id": linkedId},
        );
        break;
      case AttachmentType.course:
        await db.insert(
          "course_attachment",
          {"attachment_id": a.id, "course_id": linkedId},
        );
        break;
      case AttachmentType.certification:
        await db.update(
          "certification",
          {"attachment_id": a.id},
          where: "id = ?",
          whereArgs: [linkedId],
        );
    }
  }
}
