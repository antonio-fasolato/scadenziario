import 'package:logger/logger.dart';
import 'package:scadenziario/model/certification.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';

class CertificationRepository {
  static final Logger log = Logger();
  final SqliteConnection _connection;

  CertificationRepository(SqliteConnection connection)
      : _connection = connection;

  Future<List<Certification>> getCertificationByCourse(String id) async {
    var db = await _connection.connect();
    List<Certification> toReturn = [];
    var res = await db.query(
      "certification",
      where: "course_id = ?",
      whereArgs: [id],
    );
    if (res.isNotEmpty) {
      toReturn = List.from(res.map((e) => Certification.fromMap(e)));
    }

    await db.close();
    return toReturn;
  }
}
