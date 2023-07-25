import 'package:flutter/material.dart';
import 'package:scadenziario/model/attachment.dart';

class WithAttachments extends ChangeNotifier {
  List<Attachment> _attachments = [];

  List<Attachment> get attachments => _attachments;

  setAttachments(List<Attachment> attachments) {
    _attachments = attachments;
    notifyListeners();
  }
}
