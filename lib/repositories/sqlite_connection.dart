import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SqliteConnection {
  final Logger log = Logger();

  String? _databasePath;
  Database? _database;

  SqliteConnection._internal();

  static SqliteConnection? _instance;

  static SqliteConnection getInstance() {
    _instance ??= SqliteConnection._internal();

    return _instance as SqliteConnection;
  }

  Future<void> connect({required String databasePath}) async {
    WidgetsFlutterBinding.ensureInitialized();

    if (_databasePath != databasePath) {
      _databasePath = databasePath;
      _database = await databaseFactoryFfi.openDatabase(databasePath);
      log.d("Connected to $_databasePath");
    }
  }

  void disconnect() async {
    await _database!.close();
    log.d("Disconnected from $_databasePath");
    _databasePath = null;
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
    await _database!.execute(sql);

    sql = """
      CREATE TABLE IF NOT EXISTS "duties" (
        "id" text NOT NULL PRIMARY KEY,
        "description" text NOT NULL
      ); 
    """;
    log.d(sql);
    await _database!.execute(sql);

    sql =
        "insert into duties values ('2d9946eb-c7a1-4ed3-978c-1773babf302b', 'Impiegato');";
    log.d(sql);
    await _database!.execute(sql);

    sql =
        "insert into duties values ('2dd3b32a-79a8-4225-bb43-ba47d4dafc5a', 'Consulente esterno');";
    log.d(sql);
    await _database!.execute(sql);
  }

  bool get isConnected {
    return _database?.isOpen ?? false;
  }

  Database get database => _database as Database;
}
