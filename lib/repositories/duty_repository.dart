import 'package:logger/logger.dart';
import 'package:scadenziario/model/duty.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';

class DutyRepository {
  static final Logger log = Logger();
  final SqliteConnection _connection;

  DutyRepository(SqliteConnection connection) : _connection = connection;

  Future<List<Duty>> getAllDuties() async {
    var db = await _connection.connect();

    var res = await db.query("duties", columns: ["id", "description"]);
    List<Duty> toReturn = [];
    if (res.isNotEmpty) {
      toReturn = res.map((e) => Duty.fromMap(e)).toList();
    }
    await db.close();
    return toReturn;
  }
}
