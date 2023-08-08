import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'dart:io' as io;

import 'package:sqflite_common/sqflite_logger.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SqliteConnection {
  final log = Logger((SqliteConnection).toString());
  Database? _database;

  static final SqliteConnection _instance = SqliteConnection._internal();

  factory SqliteConnection() {
    return _instance;
  }

  SqliteConnection._internal();

  bool get isConnected => _database != null && _database!.isOpen;

  Database get db {
    if (!isConnected) {
      throw Exception("Database not connected");
    }
    return _database as Database;
  }

  connect(String databasePath) async {
    WidgetsFlutterBinding.ensureInitialized();

    if (isConnected && _database!.path == databasePath) {
      log.info("Databse already connected");
      return;
    } else if (isConnected && _database!.path != databasePath) {
      disconnect();
    }

    bool newFile = !(await io.File(databasePath).exists());
    DatabaseFactory factory = kDebugMode
        ? SqfliteDatabaseFactoryLogger(
            databaseFactoryFfi,
            options: SqfliteLoggerOptions(
              type: SqfliteDatabaseFactoryLoggerType.all,
              log: (event) => log.info(event),
            ),
          )
        : databaseFactoryFfi;
    _database = await factory.openDatabase(databasePath);
    log.info("Connected to $databasePath");
    if (newFile) {
      await _initDb(_database as Database);
    }
  }

  Future<void> disconnect() async {
    if (isConnected) {
      String path = _database!.path;
      await _database!.close();
      log.info("Disconnected from $path");
    }
  }

  Future<void> _initDb(Database db) async {
    log.info("Initializing new database");

    String sql = """
      CREATE TABLE IF NOT EXISTS "persons" (
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

    sql = """
      CREATE TABLE IF NOT EXISTS "course" (
        "id" text NOT NULL PRIMARY KEY,
        "name" text NOT NULL,
        "description" text,
        "duration" INTEGER NOT NULL,
        "enabled" integer NOT NULL DEFAULT(1),
        "deleted" integer NOT NULL DEFAULT(0)
      ); 
    """;
    await db.execute(sql);

    sql = """
      CREATE TABLE IF NOT EXISTS "attachment" (
        "id" text NOT NULL PRIMARY KEY,
        "fileName" text NOT NULL,
        "data" BLOB not null
      ); 
    """;
    await db.execute(sql);

    sql = """
      CREATE TABLE IF NOT EXISTS "course_attachment" (
        "course_id" text NOT NULL,
        "attachment_id" text NOT NULL,
        PRIMARY KEY("course_id", "attachment_id"),
        FOREIGN KEY ("course_id") REFERENCES course("id"),
        FOREIGN KEY ("attachment_id") REFERENCES attachment("id")
      )
    """;
    await db.execute(sql);

    sql = """
      CREATE TABLE IF NOT EXISTS "person_attachment" (
        "person_id" text NOT NULL,
        "attachment_id" text NOT NULL,
        PRIMARY KEY("person_id", "attachment_id"),
        FOREIGN KEY ("person_id") REFERENCES persons("id"),
        FOREIGN KEY ("attachment_id") REFERENCES attachment("id")
      )
    """;
    await db.execute(sql);

    sql = """
      CREATE TABLE IF NOT EXISTS "certification" (
        "id" text PRIMARY KEY,
        "course_id" text NOT NULL,
        "person_id" text NOT NULL,
        "issuing_date" text NOT NULL,
        "expiration_date" text NOT NULL,
        "note" text,
        "attachment_id" text NULL,
        FOREIGN KEY ("course_id") REFERENCES course("id"),
        FOREIGN KEY ("person_id") REFERENCES persons("id"),
        FOREIGN KEY ("attachment_id") REFERENCES attachment("id")
      )
    """;
    await db.execute(sql);
  }
}
