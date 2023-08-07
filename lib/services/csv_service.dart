import 'dart:io';

import 'package:logging/logging.dart';
import 'package:scadenziario/constants.dart' as Constants;
import 'package:scadenziario/lineseparator_extension.dart';

class CsvService {
  final _log = Logger((CsvService).toString());

  String toCsv(List<List<dynamic>> data) {
    String toReturn = "";

    for (var r in data) {
      var changed = r.map((e) => e is String
          ? "${Constants.csvStringFieldIdentifier}$e${Constants.csvStringFieldIdentifier}"
          : e);
      toReturn +=
          "${changed.join(Constants.csvFieldSeparator)}${Platform().lineSeparator}";
    }

    _log.info(toReturn);

    return toReturn;
  }
}
