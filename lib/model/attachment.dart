import 'dart:typed_data';

class Attachment {
  String id;
  String fileName;
  Uint8List? data;

  Attachment(this.id, this.fileName, this.data);

  @override
  String toString() {
    return 'Attachment{id: $id, fileName: $fileName, data: [binary]}';
  }

  factory Attachment.fromMap(Map<String, dynamic> map) {
    return Attachment(map["id"], map["fileName"], map["data"]);
  }

  Map<String, dynamic> toMap() {
    return {"id": id, "fileName": fileName, "data": data};
  }
}
