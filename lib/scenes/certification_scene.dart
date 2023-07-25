import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scadenziario/components/certification_list.dart';
import 'package:scadenziario/components/certification_edit.dart';
import 'package:scadenziario/components/footer.dart';
import 'package:scadenziario/dto/certification_dto.dart';
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
  @override
  void initState() {
    super.initState();
  }

  _getAllCertifications() async {
    CourseState state = Provider.of<CourseState>(context, listen: false);
    List<CertificationDto> res = [];

    res = await CertificationRepository(widget._connection)
        .getPersonsAndCertificationsByCourse(state.course.id as String);

    state.setCertifications(res);
  }

  _certificateSaved() {
    CourseState state = Provider.of<CourseState>(context, listen: false);
    state.deselectCertification();
    _getAllCertifications();
  }

  void _editCancelled() {
    CourseState state = Provider.of<CourseState>(context, listen: false);
    state.deselectCertification();
    _getAllCertifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<CourseState>(
          builder: (context, state, child) => Text(
              "Scadenziario - Certificazioni del corso \"${state.course.name}\""),
        ),
      ),
      body: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Consumer<CourseState>(
              builder: (context, state, child) => state.hasCourse
                  ? CertificationsList(
                      connection: widget._connection,
                      getAllCertifications: _getAllCertifications,
                    )
                  : Container(),
            ),
          ),
          Expanded(
            child: Consumer<CourseState>(
              builder: (context, state, child) => state.hasCertification ||
                      state.checkedCertifications.isNotEmpty
                  ? CertificationEdit(
                      connection: widget._connection,
                      confirm: _certificateSaved,
                      cancel: _editCancelled,
                    )
                  : Container(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
