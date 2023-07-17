import 'package:logging/logging.dart';
import 'package:scadenziario/model/course.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';

class CourseRepository {
  final log = Logger((CourseRepository).toString());
  final SqliteConnection _connection;

  CourseRepository(SqliteConnection connection) : _connection = connection;

  Future<List<Course>> getAll() async {
    var db = await _connection.connect();

    List<Course> toReturn = [];
    var res = await db.query("course", orderBy: "name");
    if (res.isNotEmpty) {
      toReturn = List.from(res.map((e) => Course.fromMap(map: e)));
    }

    await db.close();
    return toReturn;
  }

  Future<List<Course>> findByName(String q) async {
    var db = await _connection.connect();

    List<Course> toReturn = [];
    String sql = '''
      select *
      from course
      where 1 = 1 and (
        name like '%$q%'
        or description like '%$q%'
      )
      order by name
    ''';
    var res = await db.rawQuery(sql);
    if (res.isNotEmpty) {
      toReturn = List.from(res.map((e) => Course.fromMap(map: e)));
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
      log.info("New course $c");
      int res = await db.insert("course", c.toMap());
      await db.close();
      return res;
    } else {
      log.info("Update course $c");
      int res = await db
          .update("course", c.toMap(), where: "id = ?", whereArgs: [c.id]);
      await db.close();
      return res;
    }
  }
}
