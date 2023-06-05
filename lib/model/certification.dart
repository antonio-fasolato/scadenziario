class Certification {
  String? id;
  String? course_id;
  String? person_id;
  String? issuing_date;
  String? expiration_date;
  String? note;

  Certification(this.id, this.course_id, this.person_id, this.issuing_date,
      this.expiration_date, this.note);

  Certification.empty();

  factory Certification.fromMap(Map<String, dynamic> map) {
    return Certification(
      map["id"],
      map["course_id"],
      map["person_id"],
      map["issuing_date"],
      map["expiration_date"],
      map["note"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "course_id": course_id,
      "person_id": person_id,
      "issuing_date": issuing_date,
      "expiration_date": expiration_date,
      "note": note,
    };
  }

  @override
  String toString() {
    return 'Certification{id: $id, course_id: $course_id, person_id: $person_id, issuing_date: $issuing_date, expiration_date: $expiration_date, note: $note}';
  }
}
