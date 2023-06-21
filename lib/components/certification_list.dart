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
  final void Function() _getAllCertifications;

  const CertificationsList({
    super.key,
    required SqliteConnection connection,
    required Function() getAllCertifications,
  })  : _connection = connection,
        _getAllCertifications = getAllCertifications;

  @override
  State<CertificationsList> createState() => _CertificationsListState();
}

class _CertificationsListState extends State<CertificationsList> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget._getAllCertifications();
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  Widget _buildCertificationTile(CertificationDto c) {
    CourseState state = Provider.of<CourseState>(context, listen: false);

    if (c.certification == null) {
      return ListTile(
        title: Text("${c.person?.surname ?? ""} ${c.person?.name ?? ""}"),
        leading: const Icon(Icons.workspace_premium_outlined),
        trailing: IconButton(
          icon: state.hasCertification
              ? const Icon(Icons.edit_off)
              : state.isCertificationChecked(c.person.id as String)
                  ? const Icon(Icons.check_box_outlined)
                  : const Icon(Icons.check_box_outline_blank),
          tooltip: state.hasCertification ? "" : "Aggiungi certificato",
          onPressed: () {
            if (!state.hasCertification) {
              state.checkCertification(c.person.id as String);
            }
          },
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            state.checkedCertifications.isEmpty
                ? IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.attachment_outlined),
                    tooltip: "Allegato del certificato",
                  )
                : Container(),
            IconButton(
              icon: state.checkedCertifications.isEmpty
                  ? const Icon(Icons.edit)
                  : const Icon(Icons.edit_off),
              tooltip: "Dettagli certificato",
              onPressed: () =>
                  _editCertification(c.certification?.id as String, c.person),
            ),
          ],
        ),
        selected: state.hasCertification &&
            state.certification?.id == c.certification?.id,
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
        Consumer<CourseState>(
          builder: (context, state, child) => ListView(
            shrinkWrap: true,
            children: state.certifications
                .map(
                  (c) => _buildCertificationTile(c),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
