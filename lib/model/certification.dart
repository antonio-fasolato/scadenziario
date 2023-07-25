import 'package:intl/intl.dart';
import 'package:scadenziario/model/attachment.dart';
import 'package:scadenziario/model/course.dart';
import 'package:scadenziario/model/person.dart';

class Certification {
  String? id;
  String? courseId;
  String? personId;
  DateTime? issuingDate;
  DateTime? expirationDate;
  String? note;
  String? attachmentId;

  Person? person;
  Course? course;
  Attachment? attachment;

  Certification(this.id, this.courseId, this.personId, this.issuingDate,
      this.expirationDate, this.note, this.attachmentId);

  Certification.empty();

  factory Certification.fromMap(
      {required Map<String, dynamic> map, String prefix = ""}) {
    Certification toReturn = Certification(
      map["${prefix}id"],
      map["${prefix}course_id"],
      map["${prefix}person_id"],
      DateFormat("yyyy-MM-dd").parse(map["${prefix}issuing_date"]),
      DateFormat("yyyy-MM-dd").parse(map["${prefix}expiration_date"]),
      map["${prefix}note"],
      map["${prefix}attachment_id"],
    );

    return toReturn;
  }

  factory Certification.fromMapWithRelationships(Map<String, dynamic> map) {
    Person p = Person.partial(
      id: map["person_id"],
      name: map["name"],
      surname: map["surname"],
      birthdate: DateFormat("yyyy-MM-dd").parse(map["birthdate"]),
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

    Attachment a = Attachment.partial(
      id: map["attachment_id"],
      fileName: map["attachment_filename"],
    );

    Certification toReturn = Certification(
        map["id"],
        map["course_id"],
        map["person_id"],
        DateFormat("yyyy-MM-dd").parse(map["issuing_date"]),
        DateFormat("yyyy-MM-dd").parse(map["expiration_date"]),
        map["note"],
        map["attachment_id"]);

    toReturn.person = p;
    toReturn.course = c;
    toReturn.attachment = a;

    return toReturn;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "course_id": courseId,
      "person_id": personId,
      "issuing_date": issuingDate != null
          ? DateFormat("yyyy-MM-dd").format(issuingDate as DateTime)
          : null,
      "expiration_date": expirationDate != null
          ? DateFormat("yyyy-MM-dd").format(expirationDate as DateTime)
          : null,
      "note": note,
      "attachment_id": attachmentId
    };
  }

  @override
  String toString() {
    return 'Certification{id: $id, course_id: $courseId, person_id: $personId, issuing_date: $issuingDate, expiration_date: $expirationDate, note: $note, attachment_id: $attachmentId}';
  }
}
