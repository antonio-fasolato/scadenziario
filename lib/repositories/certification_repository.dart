import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:scadenziario/dto/certification_dto.dart';
import 'package:scadenziario/dto/notification_dto.dart';
import 'package:scadenziario/model/attachment.dart';
import 'package:scadenziario/model/certification.dart';
import 'package:scadenziario/model/course.dart';
import 'package:scadenziario/model/person.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';
import 'package:scadenziario/settings.dart';

class CertificationRepository {
  static final log = Logger((CertificationRepository).toString());

  static Future<List<CertificationDto>> getPersonsAndCertificationsByCourse(
    String id,
    String q,
  ) async {
    var db = SqliteConnection().db;
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

    if (q.isNotEmpty) {
      sql += """
        where 1 = 1
          and (
            p.name like '%$q%'
            or p.surname like '%$q%'
            or p.email like '%$q%'
          );
      """;
    }

    var res = await db.rawQuery(sql);
    if (res.isNotEmpty) {
      toReturn = List.from(
        res.map(
          (e) {
            var toReturn = CertificationDto(
              person: Person.fromMap(map: e),
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

    return toReturn;
  }

  static Future<Certification?> getById(String id) async {
    var db = SqliteConnection().db;

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

    return toReturn;
  }

  static Future<List<Certification>> getCertificationByCourse(String id) async {
    var db = SqliteConnection().db;
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

    return toReturn;
  }

  static Future<List<Certification>> getCertificationsExpiringInMonth(
      DateTime d) async {
    var db = SqliteConnection().db;
    List<Certification> toReturn = [];

    DateTime start = DateTime(d.year, d.month, 1);
    DateTime end = DateTime(d.year, d.month + 1, 0);

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
        and date(ce.expiration_date) between date('${DateFormat("yyyy-MM-dd").format(start)}') and date('${DateFormat("yyyy-MM-dd").format(end)}')
    """;

    log.info(sql);
    var res = await db.rawQuery(sql);
    if (res.isNotEmpty) {
      toReturn =
          List.from(res.map((e) => Certification.fromMapWithRelationships(e)));
    }

    return toReturn;
  }

  static Future<List<String>> getPersonsFromCourseCertificate(
      String courseId) async {
    var db = SqliteConnection().db;
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

    return toReturn;
  }

  static Future<List<CertificationDto>> getCertificationsFromPersonId(
      String personId) async {
    var db = SqliteConnection().db;
    List<CertificationDto> toReturn = [];

    String sql = """
      select
        ce.*
          , p.name, p.surname, p.birthdate, p.email, p.phone, p.mobile
        , c.id as c_id, c.name as c_name, c.description as c_description, c.duration as c_duration, c.enabled as c_enabled, c.deleted as c_deleted
      from certification ce
      inner join persons p on
        ce.person_id = p.id
      inner join course as c on
        ce.course_id = c.id
      where 1 = 1
        and p.id = '$personId'
        and p.deleted = 0
        and p.enabled = 1
        and c.deleted = 0
        and c.enabled = 1
      order by ce.expiration_date desc, ce.issuing_date desc
    """;

    var res = await db.rawQuery(sql);
    toReturn = res.map((r) {
      var toReturn = CertificationDto(
        person: Person.fromMap(map: r, prefix: "p_"),
        certification: Certification.fromMap(map: r),
        course: r["c_id"] == null ? null : Course.fromMap(map: r, prefix: "c_"),
      );
      return toReturn;
    }).toList();

    return toReturn;
  }

  static Future<int> getNotificationsCount(DateTime d) async {
    var db = SqliteConnection().db;
    Settings settings = await Settings.getInstance();

    DateTime to =
        DateTime.now().add(Duration(days: settings.daysToExpirationWarning()));

    String sql = """
      select count(*) as count
      from certification c
      where 1 = 1
        and notification_hidden = 0
        and expiration_date < DATE('${DateFormat("yyyy-MM-dd").format(to)}')
    """;

    var res = await db.rawQuery(sql);
    if (res.isNotEmpty) {
      return res.first["count"] as int;
    }

    return 0;
  }

  static Future<List<NotificationDto>> getNotifications(
      DateTime d, String q, bool hidden) async {
    var db = SqliteConnection().db;
    Settings settings = await Settings.getInstance();

    DateTime to =
        DateTime.now().add(Duration(days: settings.daysToExpirationWarning()));

    List<NotificationDto> toReturn = [];

    String fullText =
        "and (p.name like '%$q%' OR p.surname like '%$q%' or p.email like '%$q%' or c.name like '%$q%')";

    String sql = """
      select ce.*, 
        p.id as person_id, p.name as person_name, p.surname as person_surname, p.birthdate as person_birthdate, p.email as person_email, p.phone as person_phone, p.mobile as person_mobile, 
        c.name as course_name, c.description as course_description, c.duration 
      from certification ce
      inner join persons p on
        ce.person_id = p.id
      inner join course c on
        ce.course_id = c.id
      where 1 = 1
        ${hidden ? "" : "and ce.notification_hidden = 0"}
        and ce.expiration_date < DATE('${DateFormat("yyyy-MM-dd").format(to)}')
        ${q.isNotEmpty ? fullText : ""}
      order by ce.expiration_date desc
	    """;

    var res = await db.rawQuery(sql);
    if (res.isNotEmpty) {
      toReturn = List.from(
        res.map(
          (e) {
            var toReturn = NotificationDto(
              person: Person.fromMap(map: e, prefix: "person_"),
              certification:
                  e["id"] == null ? null : Certification.fromMap(map: e),
              course: e["course_id"] == null
                  ? null
                  : Course.fromMap(map: e, prefix: "course_"),
            );
            return toReturn;
          },
        ),
      );
    }

    return toReturn;
  }

  static Future<int> save(Certification c) async {
    var db = SqliteConnection().db;
    int toReturn = 0;

    var res =
        await db.query("certification", where: "id = ?", whereArgs: [c.id]);
    if (res.isEmpty) {
      toReturn = await db.insert("certification", c.toMap());
    } else {
      toReturn = await db.update("certification", c.toMap(),
          where: "id = ?", whereArgs: [c.id]);
    }

    return toReturn;
  }

  static delete(String id) async {
    var db = SqliteConnection().db;

    await db.delete("certification", where: "id = ?", whereArgs: [id]);
  }
}
