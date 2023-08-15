import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseSelectionScene extends StatefulWidget {
  static const String _recentFilesKey = "recentFiles";
  final SharedPreferences _sharedPreferences;

  const DatabaseSelectionScene({
    super.key,
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  @override
  State<DatabaseSelectionScene> createState() => _DatabaseSelectionSceneState();
}

class _DatabaseSelectionSceneState extends State<DatabaseSelectionScene> {
  bool _showRecentFiles = false;
  List<String> _recentFiles = [];

  @override
  void initState() {
    super.initState();

    _getRecentFiles();
  }

  _getRecentFiles() {
    setState(() {
      _recentFiles = widget._sharedPreferences
              .getStringList(DatabaseSelectionScene._recentFilesKey) ??
          [];
    });
  }

  List<Widget> _recentFilesTilesBuilder() {
    return List.of(
      _recentFiles.reversed.map(
        (f) => ListTile(
          contentPadding: const EdgeInsets.all(1),
          title: Text(f),
          onTap: () {
            _openDatabase(f);
          },
          trailing: IconButton(
            onPressed: () => _deleteRecent(f),
            icon: const Icon(Icons.clear),
          ),
        ),
      ),
    );
  }

  _deleteRecent(String path) {
    var oldFiles = widget._sharedPreferences
            .getStringList(DatabaseSelectionScene._recentFilesKey) ??
        [];
    oldFiles.remove(path);

    if (oldFiles.length > 10) {
      oldFiles.sublist(1);
    }

    widget._sharedPreferences
        .setStringList(DatabaseSelectionScene._recentFilesKey, oldFiles);

    setState(() {
      _recentFiles = oldFiles;
    });
  }

  void _openDatabase(String path) async {
    final navigator = Navigator.of(context);

    await SqliteConnection().connect(path);
    _pushRecentFile(path);

    navigator.pushNamedAndRemoveUntil("/home", (route) => false);
  }

  void _pushRecentFile(String path) {
    var oldFiles = widget._sharedPreferences
            .getStringList(DatabaseSelectionScene._recentFilesKey) ??
        [];
    oldFiles.remove(path);
    oldFiles.add(path);

    if (oldFiles.length > 10) {
      oldFiles.sublist(1);
    }

    widget._sharedPreferences
        .setStringList(DatabaseSelectionScene._recentFilesKey, oldFiles);

    setState(() {
      _recentFiles = oldFiles;
    });
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
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 50,
            child: Center(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/backgrounds/neve.jpg"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 50,
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
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
                                const Text(
                                  "Selezionare file di archivio",
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    await _selectDatabaseFile(context);
                                  },
                                  icon: const Icon(Icons.file_open),
                                  label: const Text("Apri o crea file"),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Visibility(
                                  visible: !_showRecentFiles,
                                  child: TextButton(
                                    child: const Text(
                                        "Oppure seleziona uno dei file usati recentemente",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    onPressed: () => setState(() {
                                      _showRecentFiles = true;
                                    }),
                                  ),
                                ),
                                Visibility(
                                  visible: _showRecentFiles,
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: _recentFilesTilesBuilder(),
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
              ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: const Footer(),
    );
  }
}
