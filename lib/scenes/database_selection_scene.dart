import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' as io;

class DatabaseSelectionScene extends StatelessWidget {
  static const String _recentFilesKey = "recentFiles";
  final SharedPreferences _sharedPreferences;

  DatabaseSelectionScene(
      {super.key, required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fileController = TextEditingController();

  // final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _passwordCheckController =
  //     TextEditingController();

  List<ListTile> _getRecentFiles() {
    List<String> files =
        _sharedPreferences?.getStringList(_recentFilesKey) ?? [];

    return List.of(files.reversed.map((f) => ListTile(
          contentPadding: const EdgeInsets.all(1),
          title: SelectableText(f),
          onTap: () {
            _fileController.text = f;
          },
        )));
  }

  void _pushRecentFile(String path) {
    var oldFiles = _sharedPreferences?.getStringList(_recentFilesKey) ?? [];
    if (!oldFiles.contains(path)) {
      oldFiles.add(path);
    }

    if (oldFiles.length > 10) {
      oldFiles.sublist(1);
    }

    _sharedPreferences.setStringList(_recentFilesKey, oldFiles);
  }

  Future<void> _selectDatabaseFile(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      SqliteConnection conn = SqliteConnection.getInstance();
      if (conn.isConnected) {
        conn.disconnect();
      }
      bool newFile = !(await io.File(_fileController.text).exists());
      await conn.connect(databasePath: _fileController.text);
      if (newFile) {
        await conn.initDb();
      }
      _pushRecentFile(_fileController.text);

      Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
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
                      Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: _fileController,
                                decoration: InputDecoration(
                                  label: const Text("File di archivio"),
                                  suffixIcon: IconButton(
                                      onPressed: () async {
                                        String? selectedPath =
                                            await FilePicker.platform.saveFile(
                                                dialogTitle:
                                                    "Selezionare il file di archivio",
                                                type: FileType.custom,
                                                allowedExtensions: [
                                              ".db",
                                              ".sqlite"
                                            ]);
                                        if (selectedPath != null) {
                                          _fileController.text = selectedPath;
                                        }
                                      },
                                      icon: const Icon(Icons.folder_open)),
                                ),
                                validator: (value) => (value?.isEmpty ?? false)
                                    ? "Selezionare un file da aprire o creare"
                                    : null,
                              ),
                              // TextFormField(
                              //   controller: _passwordController,
                              //   obscureText: true,
                              //   decoration: const InputDecoration(
                              //     label: Text("Password"),
                              //   ),
                              //   validator: (value) {
                              //     if (value?.isNotEmpty ?? false) {
                              //       if (value !=
                              //           _passwordCheckController.text) {
                              //         return "Password e controllo password devono combaciare";
                              //       }
                              //     }
                              //     return null;
                              //   },
                              // ),
                              // TextFormField(
                              //   controller: _passwordCheckController,
                              //   obscureText: true,
                              //   decoration: const InputDecoration(
                              //     label: Text("Controllo password"),
                              //   ),
                              // ),
                            ],
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Spacer(),
                          ElevatedButton(
                              onPressed: () async {
                                await _selectDatabaseFile(context);
                              },
                              child: const Text("Seleziona database")),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
              width: 450,
              child: Divider(color: Colors.grey),
            ),
            const Text("File recenti",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(
              width: 450,
              child: ListView(
                shrinkWrap: true,
                children: _getRecentFiles(),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: const Footer(),
    );
  }
}
