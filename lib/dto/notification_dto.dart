import 'package:intl/intl.dart';
import 'package:scadenziario/dto/certification_dto.dart';

class NotificationDto extends CertificationDto {
  NotificationDto({
    required super.person,
    required super.certification,
    required super.course,
  });

  static List<String> get csvHeader => [
        "Id",
        "Corso",
        "Data di scadenza",
        "Nome",
        "Cognome",
        "Nascosta",
      ];

  @override
  List<dynamic> get csvArray => [
        certification?.id ?? "",
        course?.name ?? "",
        certification?.expirationDate != null
            ? DateFormat("yyyy-MM-dd")
                .format(certification?.expirationDate as DateTime)
            : null,
        person.name,
        person.surname,
        certification?.notificationHidden ?? false ? 1 : 0
      ];
}
