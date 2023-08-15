import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scadenziario/constants.dart' as constants;
import 'package:scadenziario/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsDefaults extends StatefulWidget {
  const SettingsDefaults({super.key});

  @override
  State<SettingsDefaults> createState() => _SettingsDefaultsState();
}

class _SettingsDefaultsState extends State<SettingsDefaults> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late List<DropdownMenuItem<String>> _csvSeparatorValues;
  TextEditingController _daysToExpirationWarningController =
      TextEditingController();
  TextEditingController _stopNotifyingExpirationAfterDaysController =
      TextEditingController();
  TextEditingController _csvFieldSeparatorController = TextEditingController();
  TextEditingController _csvStringFieldIdentifierController =
      TextEditingController();

  _SettingsDefaultsState() {
    _csvSeparatorValues = [
      const DropdownMenuItem<String>(
        value: ",",
        child: Text(","),
      ),
      const DropdownMenuItem<String>(
        value: ";",
        child: Text(";"),
      ),
      const DropdownMenuItem<String>(
        value: ":",
        child: Text(":"),
      ),
      const DropdownMenuItem<String>(
        value: " ",
        child: Text("Spazio"),
      ),
      const DropdownMenuItem<String>(
        value: "\t",
        child: Text("Tab"),
      ),
    ];
  }

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
    _stopNotifyingExpirationAfterDaysController.dispose();

    super.dispose();
  }

  _loadValues() async {
    Settings settings = await Settings.getInstance();

    setState(() {
      _daysToExpirationWarningController =
          TextEditingController(text: "${settings.daysToExpirationWarning()}");

      _stopNotifyingExpirationAfterDaysController = TextEditingController(
          text: "${settings.stopNotifyingExpirationAfterDays()}");

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

      days = _stopNotifyingExpirationAfterDaysController.text;
      if (days.isEmpty) {
        sharedPreferences.remove(constants.stopNotifyingExpirationAfterDaysKey);
      } else {
        sharedPreferences.setInt(
            constants.stopNotifyingExpirationAfterDaysKey, int.parse(days));
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
            TextFormField(
              controller: _stopNotifyingExpirationAfterDaysController,
              decoration: const InputDecoration(
                label: Text(
                    "Numero di giorni dopo i quali non viene visualizzata una notifica per una certificazione scaduta (default ${constants.stopNotifyingExpirationAfterDays})"),
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
            DropdownButtonFormField<String>(
              value: _csvFieldSeparatorController.text.isEmpty
                  ? null
                  : _csvFieldSeparatorController.text,
              items: _csvSeparatorValues,
              decoration: const InputDecoration(
                label: Text(
                    "CSV: separatore di campi (default: ${constants.csvFieldSeparator})"),
                prefixIcon: Icon(Icons.format_line_spacing),
              ),
              onChanged: (value) {
                setState(() {
                  _csvFieldSeparatorController =
                      TextEditingController(text: value ?? "");
                });
              },
            ),
            TextFormField(
              controller: _csvStringFieldIdentifierController,
              decoration: const InputDecoration(
                label: Text(
                    "CSV: identificatore di stringhe (default: ${constants.csvStringFieldIdentifier})"),
                prefixIcon: Icon(Icons.text_fields),
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
