import 'package:logger/logger.dart';
import 'package:scadenziario/model/course.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';

class CourseRepository {
  static final Logger log = Logger();
  final SqliteConnection _connection;

  CourseRepository(SqliteConnection connection) : _connection = connection;

  Future<List<Course>> getAll() async {
    var db = await _connection.connect();

    List<Course> toReturn = [];
    var res = await db.query("course", orderBy: "name");
    if (res.isNotEmpty) {
      toReturn = List.from(res.map((e) => Course.fromMap(e)));
    }

    await db.close();
    return toReturn;
  }

  Future<int> save(Course c) async {
    if (c.id == null) {
      throw Exception("Course with null id");
    }

    var db = await _connection.connect();
    var res = await db.query("course", where: "id = ?", whereArgs: [c.id]);
    if (res.isEmpty) {
      log.d("New course $c");
      int res = await db.insert("course", c.toMap());
      await db.close();
      return res;
    } else {
      log.d("Update course $c");
      int res = await db
          .update("course", c.toMap(), where: "id = ?", whereArgs: [c.id]);
      await db.close();
      return res;
    }
  }
}
