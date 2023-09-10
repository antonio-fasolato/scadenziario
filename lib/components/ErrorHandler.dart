import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class ErrorHandler {
  static handleException({
    required Exception exception,
    required BuildContext context,
    Logger? log,
  }) {
    log?.severe('An error has occurred: $exception');

    final alert = AlertDialog(
      content: Text(
        'An error has occurred: $exception',
        style: const TextStyle(color: Colors.red),
      ),
    );
    showDialog(
      context: context,
      builder: (context) {
        return alert;
      },
    );
  }
}
