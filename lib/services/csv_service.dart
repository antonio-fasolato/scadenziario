import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scadenziario/constants.dart' as constants;
import 'package:scadenziario/lineseparator_extension.dart';

class CsvService {
  static String toCsv(List<List<dynamic>> data) {
    String toReturn = "";

    for (var r in data) {
      var changed = r.map((e) => e is String
          ? "${constants.csvStringFieldIdentifier}$e${constants.csvStringFieldIdentifier}"
          : e);
      toReturn +=
          "${changed.join(constants.csvFieldSeparator)}${Platform().lineSeparator}";
    }

    return toReturn;
  }

  static Future<String> save(String data) async {
    String? selectedPath = await FilePicker.platform.saveFile(
      dialogTitle: "Selezionare la cartella dove salvare l'allegato",
      allowedExtensions: ["csv"],
    );
    if (selectedPath != null) {
      File f = File(selectedPath);

      await f.writeAsString(data);

      return selectedPath;
    }
  }
}
