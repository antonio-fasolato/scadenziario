class Course {
  String? id;
  String? name;
  String? description;
  int? duration;
  bool? enabled;
  bool? deleted;

  Course(this.id, this.name, this.description, this.duration, this.enabled,
      this.deleted);

  Course.empty();

  Course.partial({
    this.id,
    this.name,
    this.description,
    this.duration,
    this.enabled,
    this.deleted,
  });

  @override
  String toString() {
    return 'Course{id: $id, name: $name, description: $description, duration: $duration, enabled: $enabled, deleted: $deleted}';
  }

  factory Course.fromMap(
      {required Map<String, dynamic> map, String prefix = ""}) {
    return Course(
      map["${prefix}id"],
      map["${prefix}name"],
      map["${prefix}description"],
      map["${prefix}duration"],
      map["${prefix}enabled"] == 1,
      map["${prefix}deleted"] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "duration": duration,
      "enabled": enabled! ? 1 : 0,
      "deleted": deleted! ? 1 : 0,
    };
  }
}
