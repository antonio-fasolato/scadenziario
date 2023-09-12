import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:scadenziario/scadenziario_exception.dart';

class ErrorHandler {
  static showError({
    required String message,
    required BuildContext context,
  }) =>
      showDialog(
        context: context,
        builder: (context) {
          return ErrorHandlerWidget(
            message: message,
          );
        },
      );

  static handleException({
    required Exception exception,
    required BuildContext context,
    Logger? log,
  }) {
    log?.severe('An error has occurred: $exception');

    showDialog(
      context: context,
      builder: (context) {
        return ErrorHandlerWidget(
          exception: exception,
        );
      },
    );
  }
}

class ErrorHandlerWidget extends StatefulWidget {
  final Exception? exception;
  final String? message;

  const ErrorHandlerWidget({super.key, this.exception, this.message});

  @override
  State<ErrorHandlerWidget> createState() => _ErrorHandlerWidgetState();
}

class _ErrorHandlerWidgetState extends State<ErrorHandlerWidget> {
  bool _showDetails = false;

  bool _unrecoverableError() {
    if (widget.exception != null && widget.exception is ScadenziarioException) {
      var e = widget.exception as ScadenziarioException;
      return !e.recoverable;
    }
    return false;
  }

  bool _recoverableError() {
    if (widget.exception != null && widget.exception is ScadenziarioException) {
      var e = widget.exception as ScadenziarioException;
      return e.recoverable;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: widget.message != null
          ? Text("${widget.message}")
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("E' avvenuto un errore inaspettato."),
                const SizedBox(height: 8),
                Visibility(
                  visible: !_showDetails,
                  child: TextButton(
                    onPressed: () => setState(
                      () {
                        _showDetails = true;
                      },
                    ),
                    child: const Text("Clicca per maggiori dettagli:"),
                  ),
                ),
                Visibility(
                  visible: _showDetails,
                  child: const Divider(),
                ),
                Visibility(
                  visible: _showDetails,
                  child: Text(widget.exception.toString()),
                ),
                Visibility(
                  visible: _showDetails,
                  child: const Divider(),
                ),
                Visibility(
                  visible: _unrecoverableError(),
                  child: const SizedBox(height: 8),
                ),
                Visibility(
                  visible: _unrecoverableError(),
                  child: const Text(
                    "L'errore non è recuperabile, quindi l'applicazione verrà chiusa",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
      title: const Text("Errore"),
      actions: [
        Visibility(
          visible: _unrecoverableError(),
          child: ElevatedButton(
            onPressed: () => exit(1),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("Chiudi l'applicazione"),
          ),
        ),
        Visibility(
          visible: _recoverableError(),
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Chiudi"),
          ),
        ),
      ],
    );
  }
}
