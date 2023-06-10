import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scadenziario/components/certification_list.dart';
import 'package:scadenziario/components/certification_edit.dart';
import 'package:scadenziario/components/footer.dart';
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

  _certificateSaved() {
    CourseState state = Provider.of<CourseState>(context, listen: false);
    state.deselectCertification();
  }

  void _editCancelled() {
    CourseState state = Provider.of<CourseState>(context, listen: false);
    state.deselectCertification();
  }

  // Widget _sidePanelBuilder() {
  //   CourseState state = Provider.of<CourseState>(context, listen: false);
  //   if (state.hasCertification) {
  //     return CertificationNew(
  //       confirm: _certificateSaved,
  //       cancel: _editCancelled,
  //       connection: widget._connection,
  //     );
  //   }
  //
  //   return Container();
  // }

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
        children: [
          Expanded(
            child: Consumer<CourseState>(
              builder: (context, state, child) =>
                  CertificationsList(connection: widget._connection),
            ),
          ),
          Expanded(
            child: Consumer<CourseState>(
              builder: (context, state, child) => state.hasCertification
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
