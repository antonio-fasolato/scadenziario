import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scadenziario/dto/certification_dto.dart';
import 'package:scadenziario/model/certification.dart';
import 'package:scadenziario/repositories/certification_repository.dart';
import 'package:scadenziario/repositories/sqlite_connection.dart';

class PersonCertificationsList extends StatelessWidget {
  final SqliteConnection _connection;
  final String _personId;

  const PersonCertificationsList({
    super.key,
    required SqliteConnection connection,
    required String personId,
  })  : _connection = connection,
        _personId = personId;

  Future<List<CertificationDto>> _getCertifications() async {
    List<CertificationDto> toReturn = [];

    toReturn = await CertificationRepository(_connection)
        .getCertificationsFromPersonId(_personId);

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
    a = "Ottenuto il ${DateFormat("dd/MM/yyyy").format(c!.issuingDate as DateTime)} - ";

    if (c.expirationDate == null) {
      b = "";
    }
    b = "In scadenza il ${DateFormat("dd/MM/yyyy").format(c!.expirationDate as DateTime)}";

    return "$a$b";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              "Certificati",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          FutureBuilder<List<CertificationDto>>(
              future: _getCertifications(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Text('Press button to start');
                  case ConnectionState.waiting:
                    return const Text('Awaiting result...');
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return ListView(
                        shrinkWrap: true,
                        children: snapshot.data
                                ?.map(
                                  (c) => ListTile(
                                    title: Text("${c.course?.name}"),
                                    subtitle: Text(_certificationSubtitle(
                                        c.certification)),
                                    tileColor: c.isExpiring
                                        ? Colors.yellowAccent
                                        : c.isExpired
                                            ? Colors.redAccent
                                            : null,
                                  ),
                                )
                                .toList() ??
                            [],
                      );
                    }
                }
              }),
        ],
      ),
    );
  }
}
