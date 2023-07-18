import 'package:scadenziario/model/certification.dart';

class EventDto {
  final String title;

  const EventDto(this.title);

  @override
  String toString() => title;

  factory EventDto.fromCertification(Certification c) {
    return EventDto(c.note ?? "");
  }
}
