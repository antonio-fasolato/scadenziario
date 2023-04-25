import 'package:logger/logger.dart';
import 'package:scadenziario/model/duty.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';

class DutyRepository {
  static final Logger log = Logger();

  static Future<List<Duty>> getAllDuties() async {
    const String sql = "SELECT * FROM duties";
    log.d(sql);

    var res = await SqliteConnection.getInstance()
        .database
        .query("duties", columns: ["id", "description"]);
    List<Duty> toReturn = [];
    if (res.isNotEmpty) {
      toReturn = res.map((e) => Duty.fromMap(e)).toList();
    }
    return toReturn;
  }
}
