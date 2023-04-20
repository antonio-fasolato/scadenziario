import 'package:intl/intl.dart';

class MasterData {
  String? id;
  String? name;
  String? surname;
  DateTime? birthdate;
  String? email;
  String? phone;
  String? mobile;
  bool? enabled;
  bool? deleted;

  MasterData(this.id, this.name, this.surname, this.birthdate, this.email,
      this.phone, this.mobile, this.enabled, this.deleted);

  @override
  String toString() {
    return 'MasterData{id: $id, name: $name, surname: $surname, birthdate: $birthdate, email: $email, phone: $phone, mobile: $mobile, enabled: $enabled, deleted: $deleted}';
  }

  factory MasterData.fromMap(Map<String, dynamic> map) {
    return MasterData(
      map["id"],
      map["name"],
      map["surname"],
      DateFormat.yMd('it_IT').parse(map["birthdate"]),
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
      "email": email,
      "phone": phone,
      "mobile": mobile,
      "enabled": enabled ?? false ? 1 : 0,
      "deleted": deleted ?? false ? 1 : 0,
    };

    return res;
  }
}
