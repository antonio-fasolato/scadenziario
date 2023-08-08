import 'package:scadenziario/dto/person_dto.dart';
import 'package:scadenziario/model/person.dart';
import 'package:scadenziario/repositories/certification_repository.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';

class PersonRepository {
  static Future<Person?> getById(String id) async {
    var db = SqliteConnection().db;

    Person? toReturn;
    var sql = '''
      select *
      from persons
      where 1 = 1
        and id = '$id' 
    ''';
    var res = await db.rawQuery(sql);
    if (res.isNotEmpty) {
      toReturn = Person.fromMap(map: res.first);
    }
    return toReturn;
  }

  static Future<List<Person>> getAll() async {
    var db = SqliteConnection().db;

    List<Person> toReturn = [];
    var res = await db.query("persons", orderBy: "surname, name");
    if (res.isNotEmpty) {
      toReturn = List.from(res.map((e) => Person.fromMap(map: e)));
    }
    return toReturn;
  }

  static Future<List<Person>> searchByName(String q) async {
    var db = SqliteConnection().db;

    List<Person> toReturn = [];
    var sql = '''
      select *
      from persons
      where 1 = 1 and (
        name like '%$q%'
        or surname like '%$q%'
        or email like '%$q%'
      )
      order by surname, name
    ''';
    var res = await db.rawQuery(sql);
    if (res.isNotEmpty) {
      toReturn = List.from(res.map((e) => Person.fromMap(map: e)));
    }
    return toReturn;
  }

  static Future<List<PersonDto>> getPersonsFromCourse(String courseId) async {
    var db = SqliteConnection().db;

    List<PersonDto> toReturn = [];
    var sql = '''
        select distinct p.*
        from persons p
        inner join certification ce on
          ce.person_id = p.id
        inner join course c on
          ce.course_id = c.id
        where 1 = 1
          and c.id = '$courseId'
	      order by surname, name
    ''';
    var res = await db.rawQuery(sql);
    for (var r in res) {
      Person p = Person.fromMap(map: r);

      var certs = await CertificationRepository.getCertificationsFromPersonId(
          p.id as String);

      toReturn.add(PersonDto.fromPerson(p, certs));
    }

    return toReturn;
  }

  static Future<int> save(Person m) async {
    if (m.id == null) {
      throw Exception("Person has null id");
    } else {
      var db = SqliteConnection().db;

      var res = await db.query("persons", where: "id = ?", whereArgs: [m.id]);
      if (res.isEmpty) {
        int res = await db.insert("persons", m.toMap());
        return res;
      } else {
        int res = await db
            .update("persons", m.toMap(), where: "id = ?", whereArgs: [m.id]);
        return res;
      }
    }
  }
}
