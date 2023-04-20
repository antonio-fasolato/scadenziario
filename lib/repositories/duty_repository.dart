import 'package:logger/logger.dart';
import 'package:scadenziario/model/duty.dart';
import 'package:sqlite_wrapper/sqlite_wrapper.dart';

class DutyRepository {
  static final Logger log = Logger();
  static final sqlWrapper = SQLiteWrapper();

  static Future<List<Duty>> getAllDuties() async {
    const String sql = "SELECT * FROM duties";
    log.d(sql);

    List<Duty> res =
        List<Duty>.from(await sqlWrapper.query(sql, fromMap: Duty.fromMap));
    return res;
  }
}
