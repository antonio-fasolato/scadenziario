import 'package:scadenziario/model/certification.dart';

class EventDto {
  final String courseName;
  final String personName;
  final DateTime expirationDate;

  const EventDto(this.courseName, this.personName, this.expirationDate);

  @override
  String toString() {
    return 'EventDto{courseTitle: $courseName, personName: $personName, expirationDate: $expirationDate}';
  }

  factory EventDto.fromCertification(Certification c) {
    return EventDto(
      "${c.course?.name}",
      "${c.person?.surname} ${c.person?.name}",
      c.expirationDate ?? DateTime.now(),
    );
  }
}
