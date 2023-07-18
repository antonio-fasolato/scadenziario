import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:scadenziario/dto/certification_dto.dart';
import 'package:scadenziario/model/attachment.dart';
import 'package:scadenziario/model/certification.dart';
import 'package:scadenziario/model/course.dart';
import 'package:scadenziario/model/person.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';

class CertificationRepository {
  final log = Logger((CertificationRepository).toString());
  final SqliteConnection _connection;

  CertificationRepository(SqliteConnection connection)
      : _connection = connection;

  Future<List<CertificationDto>> getPersonsAndCertificationsByCourse(
      String id) async {
    var db = await _connection.connect();
    List<CertificationDto> toReturn = [];

    String sql = """
    select *
    from persons as p
    left join (
      select
        c.id as c_id, c.course_id as c_course_id, c.person_id as c_person_id, c.issuing_date as c_issuing_date, c.expiration_date as c_expiration_date, c.note as c_note, c.attachment_id as c_attachment_id,
        co.id as co_id, co.name as co_name, co.description as co_description, co.duration as co_duration, co.enabled as co_enabled, co.deleted as co_deleted,
			  a.id as a_id, a.fileName as a_fileName
      from course as co
      inner join certification as c on
        co.id = c.course_id
      left join attachment a on
        a.id = c.attachment_id
      where 1 = 1
        and co.deleted = 0
        and co.id = '$id'
    ) as x on
      x.c_person_id = p.id
	    """;

    var res = await db.rawQuery(sql);
    if (res.isNotEmpty) {
      toReturn = List.from(
        res.map(
          (e) {
            var toReturn = CertificationDto(
              person: Person.fromMap(e),
              certification: e["c_id"] == null
                  ? null
                  : Certification.fromMap(map: e, prefix: "c_"),
              course: e["co_id"] == null
                  ? null
                  : Course.fromMap(map: e, prefix: "co_"),
            );
            if (e["a_id"] != null) {
              toReturn.certification!.attachment = Attachment.partial(
                id: e["a_id"] as String,
                fileName: e["a_fileName"] as String,
              );
            }
            return toReturn;
          },
        ),
      );
    }

    await db.close();
    return toReturn;
  }

  Future<Certification?> getById(String id) async {
    var db = await _connection.connect();

    String sql = """
      select ce.*, 
        p.name, p.surname, p.birthdate, p.email, p.phone, p.mobile, 
        c.name as course_name, c.description as course_description, c.duration,
        a.filename as attachment_filename
      from certification as ce
      inner join persons as p on
        p.id = ce.person_id
      inner join course as c on
        c.id = ce.course_id
      left join attachment a on
        a.id = ce.attachment_id
      where 1 = 1
        and ce.id = '$id'
        and p.enabled = 1
        and p.deleted = 0
        and c.enabled = 1
        and c.deleted = 0
    """;

    Certification? toReturn;
    var res = await db.rawQuery(sql);
    if (res.isNotEmpty) {
      toReturn = Certification.fromMapWithRelationships(res[0]);
    }

    await db.close();
    return toReturn;
  }

  Future<List<Certification>> getCertificationByCourse(String id) async {
    var db = await _connection.connect();
    List<Certification> toReturn = [];

    String sql = """
      select ce.*, 
        p.name, p.surname, p.birthdate, p.email, p.phone, p.mobile, 
        c.name as course_name, c.description as course_description, c.duration,
        a.filename as attachment_filename
      from certification as ce
      inner join persons as p on
        p.id = ce.person_id
      inner join course as c on
        c.id = ce.course_id
      left join attachment a on
        a.id = ce.attachment_id
      where 1 = 1
        and ce.course_id = '$id'
        and p.enabled = 1
        and p.deleted = 0
        and c.enabled = 1
        and c.deleted = 0
    """;

    var res = await db.rawQuery(sql);
    if (res.isNotEmpty) {
      toReturn =
          List.from(res.map((e) => Certification.fromMapWithRelationships(e)));
    }

    await db.close();
    return toReturn;
  }

  Future<List<Certification>> getCertificationExpiringInMonth(
      DateTime d) async {
    var db = await _connection.connect();
    List<Certification> toReturn = [];

    String sql = """
      select ce.*, 
        p.name, p.surname, p.birthdate, p.email, p.phone, p.mobile, 
        c.name as course_name, c.description as course_description, c.duration 
      from certification ce
      inner join persons p on
        ce.person_id = p.id
      inner join course c on
        ce.course_id = c.id
      where 1 = 1
        and date(ce.expiration_date) between date('${DateFormat("yyyy-MM-dd").format(d)}') and date('${DateFormat("yyyy-MM-dd").format(DateTime(d.year, d.month + 1, 0))}')
    """;

    log.info(sql);
    var res = await db.rawQuery(sql);
    if (res.isNotEmpty) {
      toReturn =
          List.from(res.map((e) => Certification.fromMapWithRelationships(e)));
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
