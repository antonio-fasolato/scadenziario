import 'package:logger/logger.dart';
import 'package:scadenziario/model/course.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';

class ClassRepository {
  static final Logger log = Logger();
  final SqliteConnection _connection;

  ClassRepository(SqliteConnection connection) : _connection = connection;

  Future<List<Course>> getAll() async {
    var db = await _connection.connect();

    List<Course> toReturn = [];
    var res = await db.query("class", orderBy: "name");
    if (res.isNotEmpty) {
      toReturn = List.from(res.map((e) => Course.fromMap(e)));
    }

    await db.close();
    return toReturn;
  }

  Future<int> save(Course c) async {
    if (c.id == null) {
      throw Exception("Class with null id");
    }

    var db = await _connection.connect();
    var res = await db.query("class", where: "id = ?", whereArgs: [c.id]);
    if (res.isEmpty) {
      log.d("New class $c");
      int res = await db.insert("class", c.toMap());
      await db.close();
      return res;
    } else {
      log.d("Update class $c");
      int res = await db
          .update("class", c.toMap(), where: "id = ?", whereArgs: [c.id]);
      await db.close();
      return res;
    }
  }
}
