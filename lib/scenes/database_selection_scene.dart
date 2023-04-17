import 'package:flutter/material.dart';

class DatabaseSelectionScene extends StatelessWidget {
  DatabaseSelectionScene({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordCheckController =
      TextEditingController();

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
                                      onPressed: () {},
                                      icon: const Icon(Icons.folder_open)),
                                ),
                                validator: (value) => (value?.isEmpty ?? false)
                                    ? "Selezionare un file da aprire o creare"
                                    : null,
                              ),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  label: Text("Password"),
                                ),
                                validator: (value) {
                                  if (value?.isNotEmpty ?? false) {
                                    if (value !=
                                        _passwordCheckController.text) {
                                      return "Password e controllo password devono combaciare";
                                    }
                                  }

                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _passwordCheckController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  label: Text("Controllo password"),
                                ),
                              ),
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
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      "/home", (route) => false);
                                }
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
                children: const [
                  ListTile(
                    contentPadding: EdgeInsets.all(1),
                    title: Text("C:\\lavoro\\data.db"),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.all(1),
                    title: Text("C:\\lavoro\\data.db"),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.all(1),
                    title: Text("C:\\lavoro\\data.db"),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.all(1),
                    title: Text("C:\\lavoro\\data.db"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: const Footer(),
    );
  }
}
