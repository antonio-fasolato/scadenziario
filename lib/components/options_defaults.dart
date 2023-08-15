import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scadenziario/constants.dart' as constants;
import 'package:scadenziario/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OptionsDefaults extends StatefulWidget {
  const OptionsDefaults({super.key});

  @override
  State<OptionsDefaults> createState() => _OptionsDefaultsState();
}

class _OptionsDefaultsState extends State<OptionsDefaults> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _daysToExpirationWarningController =
      TextEditingController();
  TextEditingController _csvFieldSeparatorController = TextEditingController();
  TextEditingController _csvStringFieldIdentifierController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _loadValues();
  }

  @override
  void dispose() {
    _daysToExpirationWarningController.dispose();
    _csvFieldSeparatorController.dispose();
    _csvStringFieldIdentifierController.dispose();

    super.dispose();
  }

  _loadValues() async {
    Settings settings = await Settings.getInstance();

    setState(() {
      _daysToExpirationWarningController =
          TextEditingController(text: "${settings.daysToExpirationWarning()}");

      _csvFieldSeparatorController =
          TextEditingController(text: settings.csvFieldSeparator());

      _csvStringFieldIdentifierController =
          TextEditingController(text: settings.csvStringFieldIdentifier());
    });
  }

  _saveCsvOptions() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (_formKey.currentState?.validate() ?? false) {
      var days = _daysToExpirationWarningController.text;
      if (days.isEmpty) {
        sharedPreferences.remove(constants.daysToExpirationWarningKey);
      } else {
        sharedPreferences.setInt(
            constants.daysToExpirationWarningKey, int.parse(days));
      }

      var separator = _csvFieldSeparatorController.text;
      if (separator.isEmpty) {
        sharedPreferences.remove(constants.csvFieldSeparatorKey);
      } else {
        sharedPreferences.setString(constants.csvFieldSeparatorKey, separator);
      }

      var strings = _csvStringFieldIdentifierController.text;
      if (strings.isEmpty) {
        sharedPreferences.remove(constants.csvStringFieldIdentifierKey);
      } else {
        sharedPreferences.setString(
            constants.csvStringFieldIdentifierKey, strings);
      }

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Container(
            padding: const EdgeInsets.all(16),
            height: 90,
            decoration: const BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: const Text("Opzioni salvate correttamente"),
          ),
        ),
      );
      await _loadValues();
    }
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
            TextFormField(
              controller: _csvFieldSeparatorController,
              decoration: const InputDecoration(
                label: Text(
                    "CSV: separatore di campi (default: ${constants.csvFieldSeparator})"),
                prefixIcon: Icon(Icons.calendar_month),
              ),
            ),
            TextFormField(
              controller: _csvStringFieldIdentifierController,
              decoration: const InputDecoration(
                label: Text(
                    "CSV: identificatore di stringhe (default: ${constants.csvStringFieldIdentifier})"),
                prefixIcon: Icon(Icons.calendar_month),
              ),
            ),
            Container(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async => await _saveCsvOptions(),
                  child: const Text("Salva"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
