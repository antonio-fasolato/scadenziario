import 'package:scadenziario/model/certification.dart';

class EventDto {
  final String certificationId;
  final String courseId;
  final String courseName;
  final String personId;
  final String personName;
  final DateTime expirationDate;

  const EventDto(
    this.certificationId,
    this.courseId,
    this.courseName,
    this.personId,
    this.personName,
    this.expirationDate,
  );

  @override
  String toString() {
    return 'EventDto{courseId: $courseId, courseName: $courseName, personId: $personId, personName: $personName, expirationDate: $expirationDate}';
  }

  factory EventDto.fromCertification(Certification c) {
    return EventDto(
      "${c.id}",
      "${c.course?.id}",
      "${c.course?.name}",
      "${c.person?.id}",
      "${c.person?.surname} ${c.person?.name}",
      c.expirationDate ?? DateTime.now(),
    );
  }
}
