import 'package:intl/intl.dart';
import 'package:scadenziario/model/certification.dart';
import 'package:scadenziario/model/course.dart';
import 'package:scadenziario/model/person.dart';

class CertificationDto {
  final Person person;
  final Certification? certification;
  final Course? course;

  CertificationDto({
    required this.person,
    required this.certification,
    required this.course,
  });

  bool get isExpired => certification?.isExpired ?? false;

  bool get isExpiring => certification?.isExpiring ?? false;

  static List<String> get csvHeader => [
        "Id",
        "Corso",
        "Cognome",
        "Nome",
        "Data di emissione",
        "Data di scadenza",
        "Note",
      ];

  List<dynamic> get csvArray => [
        "${certification?.id}",
        "${course?.name}",
        "${person.surname}",
        "${person.name}",
        certification?.issuingDate != null
            ? DateFormat("yyyy-MM-dd")
                .format(certification?.issuingDate as DateTime)
            : null,
        certification?.expirationDate != null
            ? DateFormat("yyyy-MM-dd")
                .format(certification?.expirationDate as DateTime)
            : null,
        "${certification?.note}",
      ];
}
