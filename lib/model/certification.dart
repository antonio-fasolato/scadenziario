import 'package:intl/intl.dart';
import 'package:scadenziario/model/course.dart';
import 'package:scadenziario/model/person.dart';

class Certification {
  String? id;
  String? courseId;
  String? personId;
  String? issuingDate;
  String? expirationDate;
  String? note;

  Person? person;
  Course? course;

  Certification(this.id, this.courseId, this.personId, this.issuingDate,
      this.expirationDate, this.note);

  Certification.empty();

  factory Certification.fromMap(
      {required Map<String, dynamic> map, String prefix = ""}) {
    Certification toReturn = Certification(
      map["${prefix}id"],
      map["${prefix}course_id"],
      map["${prefix}person_id"],
      map["${prefix}issuing_date"],
      map["${prefix}expiration_date"],
      map["${prefix}note"],
    );

    return toReturn;
  }

  factory Certification.fromMapWithRelationships(Map<String, dynamic> map) {
    Person p = Person.partial(
      id: map["person_id"],
      name: map["name"],
      surname: map["surname"],
      birthdate: DateFormat.yMd('it_IT').parse(map["birthdate"]),
      email: map["email"],
      phone: map["phone"],
      mobile: map["mobile"],
      enabled: true,
      deleted: false,
    );

    Course c = Course.partial(
      id: map["course_id"],
      name: map["course_name"],
      description: map["course_description"],
      duration: map["duration"],
      enabled: true,
      deleted: false,
    );

    Certification toReturn = Certification(
      map["id"],
      map["course_id"],
      map["person_id"],
      map["issuing_date"],
      map["expiration_date"],
      map["note"],
    );

    toReturn.person = p;
    toReturn.course = c;

    return toReturn;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "course_id": courseId,
      "person_id": personId,
      "issuing_date": issuingDate,
      "expiration_date": expirationDate,
      "note": note,
    };
  }

  @override
  String toString() {
    return 'Certification{id: $id, course_id: $courseId, person_id: $personId, issuing_date: $issuingDate, expiration_date: $expirationDate, note: $note}';
  }
}
