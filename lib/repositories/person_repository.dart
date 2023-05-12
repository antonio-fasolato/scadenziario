import 'package:logger/logger.dart';
import 'package:scadenziario/model/person.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';

class PersonRepository {
  static final Logger log = Logger();
  final SqliteConnection _connection;

  PersonRepository(SqliteConnection connection) : _connection = connection;

  Future<List<Person>> getAll() async {
    var db = await _connection.connect();

    List<Person> toReturn = [];
    var res = await db.query("masterdata", orderBy: "surname, name");
    if (res.isNotEmpty) {
      toReturn = List.from(res.map((e) => Person.fromMap(e)));
    }
    await db.close();
    return toReturn;
  }

  Future<int> save(Person m) async {
    if (m.id == null) {
      throw Exception("Masterdata has null id");
    } else {
      var db = await _connection.connect();

      var res =
          await db.query("masterdata", where: "id = ?", whereArgs: [m.id]);
      if (res.isEmpty) {
        log.d("New masterdata $m");
        int res = await db.insert("masterdata", m.toMap());
        log.d("Saved row with rowid $res");
        await db.close();
        return res;
      } else {
        log.d("Update masterdata $m");
        int res = await db.update("masterdata", m.toMap(),
            where: "id = ?", whereArgs: [m.id]);
        log.d("updated $res rows");
        await db.close();
        return res;
      }
    }
  }
}
