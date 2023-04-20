import 'package:logger/logger.dart';
import 'package:scadenziario/model/master_data.dart';
import 'package:sqlite_wrapper/sqlite_wrapper.dart';

class MasterdataRepository {
  static final Logger log = Logger();
  static final sqlWrapper = SQLiteWrapper();

  static Future<int> save(MasterData m) async {
    String sql = "select * from masterdata where id = ?";
    if (m.id == null) {
      throw Exception("Masterdata ha null id");
    } else {
      List<Object> params = [m.id as String];
      log.d({"sql": sql, "params": params});

      List<dynamic> res = await sqlWrapper.query(sql,
          params: params, fromMap: MasterData.fromMap);
      if (res.isEmpty) {
        log.d("New masterdata $m");
        int res = await sqlWrapper.insert(m.toMap(), "masterdata");
        log.d("Saved row with rowid $res");
        return res;
      } else {
        log.d("Update masterdata $m");
        int res =
            await sqlWrapper.update(m.toMap(), "masterdata", keys: ["id"]);
        log.d("updated $res rows");
        return res;
      }
    }
  }
}
