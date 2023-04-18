import 'package:logger/logger.dart';
import 'package:sqlite_wrapper/sqlite_wrapper.dart';

class SqliteConnection {
  final Logger log = Logger();
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

  bool get isConnected {
    return _databaseInfo != null;
  }
}
