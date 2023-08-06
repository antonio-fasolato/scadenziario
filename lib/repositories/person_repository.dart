import 'package:scadenziario/dto/person_dto.dart';
import 'package:scadenziario/model/person.dart';
import 'package:scadenziario/repositories/certification_repository.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';

class PersonRepository {
  final SqliteConnection _connection;

  PersonRepository(SqliteConnection connection) : _connection = connection;

  Future<Person?> getById(String id) async {
    var db = await _connection.connect();

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
    await db.close();
    return toReturn;
  }

  Future<List<Person>> getAll() async {
    var db = await _connection.connect();

    List<Person> toReturn = [];
    var res = await db.query("persons", orderBy: "surname, name");
    if (res.isNotEmpty) {
      toReturn = List.from(res.map((e) => Person.fromMap(map: e)));
    }
    await db.close();
    return toReturn;
  }

  Future<List<Person>> searchByName(String q) async {
    var db = await _connection.connect();

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
    await db.close();
    return toReturn;
  }

  Future<List<PersonDto>> getPersonsFromCourse(String courseId) async {
    var db = await _connection.connect();

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

      var certs = await CertificationRepository(_connection).getCertificationsFromPersonId(p.id as String);

      toReturn.add(PersonDto.fromPerson(p, certs));
    }

    await db.close();
    return toReturn;
  }

  Future<int> save(Person m) async {
    if (m.id == null) {
      throw Exception("Person has null id");
    } else {
      var db = await _connection.connect();

      var res = await db.query("persons", where: "id = ?", whereArgs: [m.id]);
      if (res.isEmpty) {
        int res = await db.insert("persons", m.toMap());
        await db.close();
        return res;
      } else {
        int res = await db
            .update("persons", m.toMap(), where: "id = ?", whereArgs: [m.id]);
        await db.close();
        return res;
      }
    }
  }
}
