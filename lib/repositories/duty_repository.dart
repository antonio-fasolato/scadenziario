import 'package:scadenziario/model/duty.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';

class DutyRepository {
  Future<List<Duty>> getAllDuties() async {
    var db = SqliteConnection().db;

    var res = await db.query("duties", columns: ["id", "description"]);
    List<Duty> toReturn = [];
    if (res.isNotEmpty) {
      toReturn = res.map((e) => Duty.fromMap(e)).toList();
    }
    return toReturn;
  }
}
