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

  factory Person.fromMap(
      {required Map<String, dynamic> map, String prefix = ""}) {
    return Person(
      map["${prefix}id"],
      map["${prefix}name"],
      map["${prefix}surname"],
      map["${prefix}birthdate"] == null
          ? null
          : DateFormat("yyyy-MM-dd").parse(map["${prefix}birthdate"]),
      map["${prefix}duty"],
      map["${prefix}email"],
      map["${prefix}phone"],
      map["${prefix}mobile"],
      map["${prefix}enabled"] == 1,
      map["${prefix}deleted"] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> res = {
      "id": id,
      "name": name,
      "surname": surname,
      "birthdate": birthdate != null
          ? DateFormat("yyyy-MM-dd").format(birthdate as DateTime)
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

  static List<String> get csvHeader => [
        "Id",
        "Nome",
        "Cognome",
        "Data di nascita",
        "Ruolo",
        "Email",
        "Telefono",
        "Cellulare",
        "Attivo",
        "Cancellato",
      ];

  List<dynamic> get csvArray => [
        id,
        name,
        surname,
        birthdate != null
            ? DateFormat("yyyy-MM-dd").format(birthdate as DateTime)
            : null,
        duty,
        email,
        phone,
        mobile,
        enabled ?? false ? 1 : 0,
        deleted ?? false ? 1 : 0,
      ];
}
