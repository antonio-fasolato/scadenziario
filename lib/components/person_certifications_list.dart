import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scadenziario/dto/certification_dto.dart';
import 'package:scadenziario/model/certification.dart';
import 'package:scadenziario/model/course.dart';
import 'package:scadenziario/model/person.dart';
import 'package:scadenziario/repositories/certification_repository.dart';
import 'package:scadenziario/services/csv_service.dart';
import 'package:scadenziario/state/course_state.dart';

class PersonCertificationsList extends StatelessWidget {
  final Person _person;

  const PersonCertificationsList({
    super.key,
    required Person person,
  }) : _person = person;

  Future<List<CertificationDto>> _getCertifications() async {
    List<CertificationDto> toReturn = [];

    toReturn = await CertificationRepository.getCertificationsFromPersonId(
        _person.id as String);

    return toReturn;
  }

  String _certificationSubtitle(Certification? c) {
    if (c == null) {
      return "";
    }

    String a, b;

    if (c.issuingDate == null) {
      a = "";
    }
    a = "Ottenuto il ${DateFormat("dd/MM/yyyy").format(c.issuingDate as DateTime)} - ";

    if (c.expirationDate == null) {
      b = "";
    }
    b = "In scadenza il ${DateFormat("dd/MM/yyyy").format(c.expirationDate as DateTime)}";

    return "$a$b";
  }

  _goToCourse(BuildContext context, CertificationDto c) async {
    final navigator = Navigator.of(context);

    CourseState state = Provider.of<CourseState>(context, listen: false);
    state.selectCourse(c.course as Course);
    state.selectCertification(c.certification as Certification, c.person);

    navigator.pushNamed("/certificates");
  }

  _toCsv(List<CertificationDto> certifications) async {
    List<List<dynamic>> data = [];
    data.add(CertificationDto.csvHeader);
    for (var c in certifications) {
      if (c.certification != null) {
        data.add(CertificationDto(
          certification: c.certification,
          person: _person,
          course: null,
        ).csvArray);
      }
    }

    await CsvService.save(CsvService.toCsv(data));
  }

  ListTile _buildTile(BuildContext context, CertificationDto c) {
    return ListTile(
      title: Text("${c.course?.name}"),
      subtitle: Text(_certificationSubtitle(c.certification)),
      leading: IconButton(
        icon: const Icon(Icons.workspace_premium_outlined),
        onPressed: () => _goToCourse(context, c),
      ),
      tileColor: c.isExpiring
          ? Colors.yellowAccent
          : c.isExpired
              ? Colors.redAccent
              : null,
    );
  }

  Widget _alternativeText(String s) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          s,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: FutureBuilder<List<CertificationDto>>(
        future: _getCertifications(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return _alternativeText("Caricamento");
            case ConnectionState.waiting:
              return _alternativeText("Caricamento");
            default:
              if (snapshot.hasError) {
                return _alternativeText('Error: ${snapshot.error}');
              } else {
                if (snapshot.data != null &&
                    (snapshot.data?.length ?? 0) > 0) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Certificati",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            IconButton(
                              onPressed: () => _toCsv(snapshot.data ?? []),
                              icon: const Icon(Icons.save),
                              tooltip: "Salva come csv",
                            )
                          ],
                        ),
                      ),
                      ListView.builder(
                        itemBuilder: (context, index) =>
                            _buildTile(context, snapshot.data![index]),
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                    ],
                  );
                }
                return _alternativeText("Nessun certificato presente");
              }
          }
        },
      ),
    );
  }
}
