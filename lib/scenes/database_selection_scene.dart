import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseSelectionScene extends StatefulWidget {
  static const String _recentFilesKey = "recentFiles";
  final SharedPreferences _sharedPreferences;
  final Function(SqliteConnection) _setSqliteConnection;

  const DatabaseSelectionScene(
      {super.key,
      required SharedPreferences sharedPreferences,
      required Function(SqliteConnection) setSqliteConnection})
      : _sharedPreferences = sharedPreferences,
        _setSqliteConnection = setSqliteConnection;

  @override
  State<DatabaseSelectionScene> createState() => _DatabaseSelectionSceneState();
}

class _DatabaseSelectionSceneState extends State<DatabaseSelectionScene> {
  bool _showRecentFiles = false;

  List<ListTile> _getRecentFiles() {
    List<String> files = widget._sharedPreferences
            ?.getStringList(DatabaseSelectionScene._recentFilesKey) ??
        [];

    return List.of(files.reversed.map((f) => ListTile(
          contentPadding: const EdgeInsets.all(1),
          title: SelectableText(f),
          onTap: () {
            _openDatabase(f);
          },
        )));
  }

  void _openDatabase(String path) {
    widget._setSqliteConnection(SqliteConnection(path));
    _pushRecentFile(path);

    Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
  }

  void _pushRecentFile(String path) {
    var oldFiles = widget._sharedPreferences
            ?.getStringList(DatabaseSelectionScene._recentFilesKey) ??
        [];
    if (!oldFiles.contains(path)) {
      oldFiles.add(path);
    }

    if (oldFiles.length > 10) {
      oldFiles.sublist(1);
    }

    widget._sharedPreferences
        .setStringList(DatabaseSelectionScene._recentFilesKey, oldFiles);
  }

  Future<void> _selectDatabaseFile(BuildContext context) async {
    String? selectedPath = await FilePicker.platform.saveFile(
        dialogTitle: "Selezionare il file di archivio",
        type: FileType.custom,
        allowedExtensions: ["db", "sqlite"]);
    if (selectedPath != null) {
      _openDatabase(selectedPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scadenziario - Selezione archivio di lavoro"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 450,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Selezionare file di archivio",
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            await _selectDatabaseFile(context);
                          },
                          child: const Text("Seleziona database")),
                      const SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: !_showRecentFiles,
                        child: TextButton(
                          child: const Text(
                              "Oppure seleziona uno dei file usati recentemente",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () => setState(() {
                            _showRecentFiles = true;
                          }),
                        ),
                      ),
                      Visibility(
                        visible: _showRecentFiles,
                        child: ListView(
                          shrinkWrap: true,
                          children: _getRecentFiles(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: const Footer(),
    );
  }
}
