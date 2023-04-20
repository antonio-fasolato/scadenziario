import 'package:logger/logger.dart';
import 'package:sqlite_wrapper/sqlite_wrapper.dart';

class SqliteConnection {
  final Logger log = Logger();
  static final sqlWrapper = SQLiteWrapper();
  String? _databasePath;
  DatabaseInfo? _databaseInfo;

  SqliteConnection._internal();

  static SqliteConnection getInstance() {
    SqliteConnection instance = SqliteConnection._internal();

    return instance;
  }

  Future<DatabaseInfo?> connect({required String databasePath}) async {
    if (_databasePath != databasePath) {
      _databasePath = databasePath;
      _databaseInfo = await SQLiteWrapper().openDB(databasePath);
      log.d("Connected to ${_databaseInfo?.path}");
    }

    return _databaseInfo;
  }

  void disconnect() async {
    if (_databaseInfo != null) {
      String? path = _databaseInfo?.path;
      SQLiteWrapper().closeDB();
      _databaseInfo = null;
      _databasePath = null;
      log.d("Disconnected from $path");
    }
  }

  Future<void> initDb() async {
    log.d("Initializing new database");

    String sql = """
      CREATE TABLE IF NOT EXISTS "masterdata" (
        "id" text NOT NULL PRIMARY KEY,
        "name" text NOT NULL,
        "surname" text NOT NULL,
        "birthdate" text NOT NULL,
        "email" text NOT NULL,
        "phone" text,
        "mobile" text,
        "enabled" integer NOT NULL DEFAULT(1),
        "deleted" integer NOT NULL DEFAULT(0)
      ); 
    """;
    log.d(sql);
    await sqlWrapper.execute(sql);

    sql = """
      CREATE TABLE IF NOT EXISTS "duties" (
        "id" text NOT NULL PRIMARY KEY,
        "description" text NOT NULL
      ); 
      insert into duties values ('2d9946eb-c7a1-4ed3-978c-1773babf302b', 'Impiegato');
      insert into duties values ('2dd3b32a-79a8-4225-bb43-ba47d4dafc5a', 'Consulente esterno');
    """;
    log.d(sql);
    await sqlWrapper.execute(sql);

    sql =
        "insert into duties values ('2d9946eb-c7a1-4ed3-978c-1773babf302b', 'Impiegato');";
    log.d(sql);
    await sqlWrapper.execute(sql);

    sql =
        "insert into duties values ('2dd3b32a-79a8-4225-bb43-ba47d4dafc5a', 'Consulente esterno');";
    log.d(sql);
    await sqlWrapper.execute(sql);
  }

  bool get isConnected {
    return _databaseInfo != null;
  }
}
