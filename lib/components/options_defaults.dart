import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scadenziario/constants.dart' as constants;

class OptionsDefaults extends StatefulWidget {
  const OptionsDefaults({super.key});

  @override
  State<OptionsDefaults> createState() => _OptionsDefaultsState();
}

class _OptionsDefaultsState extends State<OptionsDefaults> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _daysToExpirationWarningController =
      TextEditingController();

  @override
  void dispose() {
    _daysToExpirationWarningController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text(
              "Impostazioni di default",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Opzioni calendario",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            TextFormField(
              controller: _daysToExpirationWarningController,
              decoration: const InputDecoration(
                label: Text(
                    "Numero di giorni per considerare un certificato in scadenza (default ${constants.daysToExpirationWarning})"),
                prefixIcon: Icon(Icons.calendar_month),
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Opzioni esportazioni in csv",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
