import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scadenziario/components/footer.dart';
import 'package:scadenziario/model/certification.dart';
import 'package:scadenziario/repositories/certification_repository.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';
import 'package:scadenziario/state/course_state.dart';

class CertificateScene extends StatefulWidget {
  final SqliteConnection _connection;

  const CertificateScene({
    super.key,
    required SqliteConnection connection,
  }) : _connection = connection;

  @override
  State<CertificateScene> createState() => _CertificateSceneState();
}

class _CertificateSceneState extends State<CertificateScene> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  List<Certification> _certificates = [];

  @override
  void initState() {
    super.initState();
    _getAllCertificates();
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  _getAllCertificates() async {
    List<Certification> res = [];

    CourseState state = Provider.of<CourseState>(context, listen: false);
    if (state.hasCourse) {
      res = await CertificationRepository(widget._connection)
          .getCertificationByCourse(state.course.id as String);
    }

    setState(() {
      _certificates = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<CourseState>(
          builder: (context, state, child) => Text(
              "Scadenziario - Certificati del corso \"${state.course.name}\""),
        ),
      ),
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 30,
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      label: Text("Cerca"),
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: Icon(Icons.backspace),
                    ),
                  ),
                ),
                ListView(
                  shrinkWrap: true,
                  children: _certificates
                      .map(
                        (c) => ListTile(
                          title: Text(
                              "${c.person?.surname ?? ""} ${c.person?.name ?? ""}"),
                          subtitle: Text(
                              "Conseguito il ${c.issuingDate} - Prossima scadenza il ${c.expirationDate}"),
                          leading: const Icon(Icons.workspace_premium_outlined),
                          trailing: IconButton(
                            icon: const Icon(Icons.link_off),
                            color: Colors.red,
                            tooltip: "Elimina certificato",
                            onPressed: () {},
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
