import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scadenziario/dto/certification_dto.dart';
import 'package:scadenziario/model/certification.dart';
import 'package:scadenziario/model/person.dart';
import 'package:scadenziario/repositories/certification_repository.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';
import 'package:scadenziario/state/course_state.dart';

class CertificationsList extends StatefulWidget {
  final SqliteConnection _connection;

  const CertificationsList({
    super.key,
    required SqliteConnection connection,
  }) : _connection = connection;

  @override
  State<CertificationsList> createState() => _CertificationsListState();
}

class _CertificationsListState extends State<CertificationsList> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  List<CertificationDto> _certificates = [];

  @override
  void initState() {
    super.initState();
    _getAllCertifications();
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  _getAllCertifications() async {
    List<CertificationDto> res = [];

    CourseState state = Provider.of<CourseState>(context, listen: false);
    if (state.hasCourse) {
      res = await CertificationRepository(widget._connection)
          .getPersonsAndCertificationsByCourse(state.course.id as String);
    }

    setState(() {
      _certificates = res;
    });
  }

  Widget _buildCertificationTile(CertificationDto c) {
    CourseState state = Provider.of<CourseState>(context, listen: false);

    if (c.certification == null) {
      return ListTile(
        title: Text("${c.person?.surname ?? ""} ${c.person?.name ?? ""}"),
        leading: const Icon(Icons.workspace_premium_outlined),
        trailing: IconButton(
          icon: const Icon(Icons.add),
          tooltip: "Aggiungi certificato",
          onPressed: () => _addCertification(c.person),
        ),
        selected: state.hasPerson && state.person.id == c.person?.id,
        selectedTileColor: Colors.grey,
        selectedColor: Colors.white70,
      );
    } else {
      return ListTile(
        title: Text("${c.person?.surname ?? ""} ${c.person?.name ?? ""}"),
        subtitle: Text(
            "Conseguito il ${c.certification?.issuingDate} - Prossima scadenza il ${c.certification?.expirationDate}"),
        leading: const Icon(Icons.workspace_premium_outlined),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          tooltip: "Dettagli certificato",
          onPressed: () => _editCertification(c.certification?.id as String, c.person),
        ),
        selected: state.hasCertification &&
            state.certification.id == c.certification?.id,
        selectedTileColor: Colors.grey,
        selectedColor: Colors.white70,
      );
    }
  }

  _addCertification(Person p) {
    CourseState state = Provider.of<CourseState>(context, listen: false);

    state.selectCertification(Certification.empty(), p);
  }

  _editCertification(String id, Person p) async {
    CourseState state = Provider.of<CourseState>(context, listen: false);

    Certification? c =
        await CertificationRepository(widget._connection).getById(id);
    if (c != null) {
      state.selectCertification(c, p);
    }
  }

  _deleteCertification(String id) {
    final navigator = Navigator.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Eliminare il certificato?"),
          actions: [
            TextButton(
              onPressed: () {
                navigator.pop();
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                await CertificationRepository(widget._connection).delete(id);
                await _getAllCertifications();
                navigator.pop();
              },
              child: const Text("Si"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                (c) => _buildCertificationTile(c),
              )
              .toList(),
        ),
      ],
    );
  }
}
