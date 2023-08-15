class Duty {
  String? id;
  String? description;

  Duty(this.id, this.description);

  Duty.empty() {
    id = "";
    description = "";
  }

  factory Duty.fromMap(Map<String, dynamic> map) {
    return Duty(
      map["id"],
      map["description"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "description": description,
    };
  }

  @override
  String toString() {
    return 'Duty{id: $id, description: $description}';
  }
}
