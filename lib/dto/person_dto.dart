import 'package:scadenziario/dto/certification_dto.dart';
import 'package:scadenziario/model/person.dart';

class PersonDto {
  final String id;
  final String name;
  final String surname;
  final DateTime birthdate;
  final String? duty;
  final String? email;
  final String? phone;
  final String? mobile;
  final bool enabled;
  final bool deleted;
  final List<CertificationDto> certifications;

  const PersonDto(
    this.id,
    this.name,
    this.surname,
    this.birthdate,
    this.duty,
    this.email,
    this.phone,
    this.mobile,
    this.enabled,
    this.deleted,
    this.certifications,
  );

  factory PersonDto.fromPerson(
      Person p, List<CertificationDto> certifications) {
    if (p.id == null ||
        p.name == null ||
        p.surname == null ||
        p.enabled == null ||
        p.deleted == null) {
      throw Exception("Person has null values");
    }
    return PersonDto(
      p.id as String,
      p.name as String,
      p.surname as String,
      p.birthdate as DateTime,
      p.duty,
      p.email,
      p.phone,
      p.mobile,
      p.enabled as bool,
      p.deleted as bool,
      certifications,
    );
  }

  Person get person => Person(
        id,
        name,
        surname,
        birthdate,
        duty,
        email,
        phone,
        mobile,
        enabled,
        deleted,
      );
}
