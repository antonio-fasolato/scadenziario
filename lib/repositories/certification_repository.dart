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

    String sql = """
      select ce.*, p.name, p.surname, p.birthdate, p.email, p.phone, p.mobile, c.name as course_name, c.description as course_description, c.duration
      from certification as ce
      inner join persons as p on
        p.id = ce.person_id
      inner join course as c on
        c.id = ce.course_id
      where 1 = 1
        and ce.course_id = '$id'
        and p.enabled = 1
        and p.deleted = 0
        and c.enabled = 1
        and c.deleted = 0
    """;

    var res = await db.rawQuery(sql);
    if (res.isNotEmpty) {
      toReturn = List.from(res.map((e) => Certification.fromMap(e)));
    }

    await db.close();
    return toReturn;
  }

  Future<List<String>> getPersonsFromCourseCertificate(String courseId) async {
    var db = await _connection.connect();
    List<String> toReturn = [];

    String sql = """
      select person_id
      from certification
      where 1 = 1
        and course_id = '$courseId'
    """;

    var res = await db.rawQuery(sql);
    if (res.isNotEmpty) {
      toReturn = List.from(res.map((e) => e["person_id"]));
    }

    await db.close();
    return toReturn;
  }

  Future<int> save(Certification c) async {
    var db = await _connection.connect();
    int toReturn = 0;

    var res =
        await db.query("certification", where: "id = ?", whereArgs: [c.id]);
    if (res.isEmpty) {
      toReturn = await db.insert("certification", c.toMap());
    } else {
      toReturn = await db.update("certification", c.toMap(),
          where: "id = ?", whereArgs: [c.id]);
    }

    await db.close();
    return toReturn;
  }

  delete(String id) async {
    var db = await _connection.connect();

    await db.delete("certification", where: "id = ?", whereArgs: [id]);

    await db.close();
  }
}
