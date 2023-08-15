import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scadenziario/components/app_bar_title.dart';
import 'package:scadenziario/components/certification_list.dart';
import 'package:scadenziario/components/certification_edit.dart';
import 'package:scadenziario/components/footer.dart';
import 'package:scadenziario/dto/certification_dto.dart';
import 'package:scadenziario/repositories/certification_repository.dart';
import 'package:scadenziario/state/course_state.dart';

class CertificateScene extends StatefulWidget {
  const CertificateScene({super.key});

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

    res = await CertificationRepository.getPersonsAndCertificationsByCourse(
      state.course.id as String,
      state.searchController.text,
    );

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

  String _getTitile() {
    CourseState state = Provider.of<CourseState>(context, listen: false);

    return "Scadenziario - Certificazioni del corso \"${state.course.name}\"";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(title: _getTitile()),
      ),
      body: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Consumer<CourseState>(
              builder: (context, state, child) => state.hasCourse
                  ? CertificationsList(
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
