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
}
