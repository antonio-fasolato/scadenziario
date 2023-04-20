import 'package:flutter/material.dart';
import 'package:scadenziario/model/duty.dart';
import 'package:scadenziario/repositories/duty_repository.dart';

class PeopleNew extends StatefulWidget {
  late void Function() _confirm;

  PeopleNew({super.key, required void Function() confirm}) : _confirm = confirm;

  @override
  State<PeopleNew> createState() => _PeopleNewState();
}

class _PeopleNewState extends State<PeopleNew> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  List<Duty> _duties = [];
  String? _dutyId;

  @override
  void initState() {
    super.initState();

    _loadDuties();
  }

  Future<void> _loadDuties() async {
    var duties = await DutyRepository.getAllDuties();

    setState(() {
      _duties = duties;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Text("Nuova persona",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: Text("Dati anagrafici",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Form(
              key: _formKey,
              child: Table(
                children: [
                  TableRow(children: [
                    TableCell(
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                            label: Text("Nome"),
                            prefixIcon: Icon(Icons.person)),
                      ),
                    ),
                    TableCell(
                      child: TextFormField(
                        controller: _surnameController,
                        decoration: const InputDecoration(
                            label: Text("Cognome"),
                            prefixIcon: Icon(Icons.person)),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: TextFormField(
                      controller: _birthDateController,
                      decoration: const InputDecoration(
                          label: Text("Data di nascita"),
                          prefixIcon: Icon(Icons.calendar_month)),
                    )),
                    TableCell(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          label: Text("Mansione"),
                          prefixIcon: Icon(Icons.work)
                        ),
                        items: _duties
                            .map<DropdownMenuItem<String>>((d) =>
                                DropdownMenuItem<String>(
                                    value: d.id,
                                    child: Text(d.description ?? "")))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _dutyId = value;
                          });
                        },
                      ),
                      //     TextFormField(
                      //   controller: _jobController,
                      //   decoration: const InputDecoration(
                      //       label: Text("Mansione"),
                      //       prefixIcon: Icon(Icons.work)),
                      // ),
                    )
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: TextFormField(
                      controller: _mailController,
                      decoration: const InputDecoration(
                          label: Text("Email"), prefixIcon: Icon(Icons.mail)),
                    )),
                    Container()
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                          label: Text("Telefono"),
                          prefixIcon: Icon(Icons.phone)),
                    )),
                    TableCell(
                        child: TextFormField(
                      controller: _mobileController,
                      decoration: const InputDecoration(
                          label: Text("Cellulare"),
                          prefixIcon: Icon(Icons.phone_android)),
                    ))
                  ]),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: ElevatedButton(
                    onPressed: () => widget._confirm(),
                    child: const Text("Inserisci"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
