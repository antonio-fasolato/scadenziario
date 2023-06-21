import 'package:intl/intl.dart';

class Person {
  String? id;
  String? name;
  String? surname;
  DateTime? birthdate;
  String? duty;
  String? email;
  String? phone;
  String? mobile;
  bool? enabled;
  bool? deleted;

  Person(this.id, this.name, this.surname, this.birthdate, this.duty,
      this.email, this.phone, this.mobile, this.enabled, this.deleted);

  Person.empty();

  Person.partial({
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
  });

  @override
  String toString() {
    return 'Person{id: $id, name: $name, surname: $surname, birthdate: $birthdate, duty: $duty, email: $email, phone: $phone, mobile: $mobile, enabled: $enabled, deleted: $deleted}';
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      map["id"],
      map["name"],
      map["surname"],
      DateFormat.yMd('it_IT').parse(map["birthdate"]),
      map["duty"],
      map["email"],
      map["phone"],
      map["mobile"],
      map["enabled"] == 1,
      map["deleted"] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> res = {
      "id": id,
      "name": name,
      "surname": surname,
      "birthdate": birthdate != null
          ? DateFormat.yMd('it_IT').format(birthdate ?? DateTime.now())
          : null,
      "duty": duty,
      "email": email,
      "phone": phone,
      "mobile": mobile,
      "enabled": enabled ?? false ? 1 : 0,
      "deleted": deleted ?? false ? 1 : 0,
    };

    return res;
  }
}
