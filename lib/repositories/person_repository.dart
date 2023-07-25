import 'package:scadenziario/model/person.dart';
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
      toReturn = Person.fromMap(res.first);
    }
    await db.close();
    return toReturn;
  }

  Future<List<Person>> getAll() async {
    var db = await _connection.connect();

    List<Person> toReturn = [];
    var res = await db.query("persons", orderBy: "surname, name");
    if (res.isNotEmpty) {
      toReturn = List.from(res.map((e) => Person.fromMap(e)));
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
      toReturn = List.from(res.map((e) => Person.fromMap(e)));
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
