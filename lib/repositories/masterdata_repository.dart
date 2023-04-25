import 'package:logger/logger.dart';
import 'package:scadenziario/model/master_data.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';

class MasterdataRepository {
  static final Logger log = Logger();

  static Future<List<MasterData>> getAll() async {
    String sql = "select * from masterdata order by surname, name";
    log.d(sql);
    List<MasterData> toReturn = [];
    var res = await SqliteConnection.getInstance()
        .database
        .query("masterdata", orderBy: "surname, name");
    if (res.isNotEmpty) {
      toReturn = List.from(res.map((e) => MasterData.fromMap(e)));
    }
    return toReturn;
  }

  static Future<int> save(MasterData m) async {
    if (m.id == null) {
      throw Exception("Masterdata has null id");
    } else {
      var res = await SqliteConnection.getInstance()
          .database
          .query("masterdata", where: "id = ?", whereArgs: [m.id]);
      if (res.isEmpty) {
        log.d("New masterdata $m");
        int res = await SqliteConnection.getInstance()
            .database
            .insert("masterdata", m.toMap());
        log.d("Saved row with rowid $res");
        return res;
      } else {
        log.d("Update masterdata $m");
        int res = await SqliteConnection.getInstance().database.update(
            "masterdata", m.toMap(),
            where: "id = ?", whereArgs: [m.id]);
        log.d("updated $res rows");
        return res;
      }
    }
  }
}
