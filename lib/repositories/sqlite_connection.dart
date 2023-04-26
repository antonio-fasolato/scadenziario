import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sqflite_common/sqflite_logger.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' as io;

class SqliteConnection {
  final Logger log = Logger();
  final String _databasePath;

  SqliteConnection(this._databasePath);

  Future<Database> connect() async {
    WidgetsFlutterBinding.ensureInitialized();

    bool newFile = !(await io.File(_databasePath).exists());
    DatabaseFactory factory = kDebugMode
        ? SqfliteDatabaseFactoryLogger(databaseFactoryFfi,
            options: SqfliteLoggerOptions(
              type: SqfliteDatabaseFactoryLoggerType.all,
              log: (event) => log.d(event),
            ))
        : databaseFactoryFfi;
    var db = await factory.openDatabase(_databasePath);
    log.d("Connected to $_databasePath");
    if (newFile) {
      await _initDb(db);
    }

    return db;
  }

  Future<void> _initDb(Database db) async {
    log.d("Initializing new database");

    String sql = """
      CREATE TABLE IF NOT EXISTS "masterdata" (
        "id" text NOT NULL PRIMARY KEY,
        "name" text NOT NULL,
        "surname" text NOT NULL,
        "birthdate" text NOT NULL,
        "duty" text NOT NULL,
        "email" text NOT NULL,
        "phone" text,
        "mobile" text,
        "enabled" integer NOT NULL DEFAULT(1),
        "deleted" integer NOT NULL DEFAULT(0)
      ); 
    """;
    await db.execute(sql);

    sql = """
      CREATE TABLE IF NOT EXISTS "duties" (
        "id" text NOT NULL PRIMARY KEY,
        "description" text NOT NULL
      ); 
    """;
    await db.execute(sql);

    sql =
        "insert into duties values ('2d9946eb-c7a1-4ed3-978c-1773babf302b', 'Impiegato');";
    await db.execute(sql);

    sql =
        "insert into duties values ('2dd3b32a-79a8-4225-bb43-ba47d4dafc5a', 'Consulente esterno');";
    await db.execute(sql);
  }
}
