import 'package:scadenziario/model/duty.dart';
import 'package:scadenziario/model/person.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';
import 'package:uuid/uuid.dart';

class DutyRepository {
  static Future<List<Duty>> getAllDuties() async {
    var db = SqliteConnection().db;

    var res = await db.query("duties", columns: ["id", "description"]);
    List<Duty> toReturn = [];
    if (res.isNotEmpty) {
      toReturn = res.map((e) => Duty.fromMap(e)).toList();
    }
    return toReturn;
  }

  static Future<int> save(Duty d) async {
    d.id ??= const Uuid().v4().toString();

    var db = SqliteConnection().db;
    return await db.insert("duties", d.toMap());
  }

  static Future<List<Person>> getPersonsFromDuty(Duty d) async {
    var db = SqliteConnection().db;

    if (d.id == null) {
      return [];
    }

    var res = await db.query("persons", where: "duty = ?", whereArgs: [d.id]);
    return res.map((p) => Person.fromMap(map: p)).toList();
  }

  static Future<int> delete(Duty d) async {
    var db = SqliteConnection().db;
    return await db.delete("duties", where: "id = ?", whereArgs: [d.id]);
  }
}
