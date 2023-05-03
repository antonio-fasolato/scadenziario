import 'package:logger/logger.dart';
import 'package:scadenziario/model/attachment.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';

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
}
