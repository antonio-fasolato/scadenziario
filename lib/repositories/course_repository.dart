import 'package:logging/logging.dart';
import 'package:scadenziario/model/course.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';

class CourseRepository {
  final log = Logger((CourseRepository).toString());

  Future<Course?> getById(String id) async {
    var db = SqliteConnection().db;
    Course? toReturn;

    String sql = '''
      select *
      from course
      where 1 = 1 
        and id = '$id'
    ''';
    var res = await db.rawQuery(sql);
    if (res.isNotEmpty) {
      toReturn = Course.fromMap(map: res.first);
    }

    return toReturn;
  }

  Future<List<Course>> getAll() async {
    var db = SqliteConnection().db;

    List<Course> toReturn = [];
    var res = await db.query("course", orderBy: "name");
    if (res.isNotEmpty) {
      toReturn = List.from(res.map((e) => Course.fromMap(map: e)));
    }

    return toReturn;
  }

  Future<List<Course>> findByName(String q) async {
    var db = SqliteConnection().db;

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

    return toReturn;
  }

  Future<int> save(Course c) async {
    if (c.id == null) {
      throw Exception("Course with null id");
    }

    var db = SqliteConnection().db;
    var res = await db.query("course", where: "id = ?", whereArgs: [c.id]);
    if (res.isEmpty) {
      log.info("New course $c");
      int res = await db.insert("course", c.toMap());
      return res;
    } else {
      log.info("Update course $c");
      int res = await db
          .update("course", c.toMap(), where: "id = ?", whereArgs: [c.id]);
      return res;
    }
  }
}
