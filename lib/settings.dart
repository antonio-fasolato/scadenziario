import 'package:shared_preferences/shared_preferences.dart';
import 'package:scadenziario/constants.dart' as constants;

class Settings {
  static final Settings _instance = Settings._internal();

  static Future<Settings> getInstance() async {
    _instance._preferences ??= await SharedPreferences.getInstance();
    return _instance;
  }

  Settings._internal();

  SharedPreferences? _preferences;

  int daysToExpirationWarning() {
    int toReturn = constants.daysToExpirationWarning;

    if (_preferences!.containsKey(constants.daysToExpirationWarningKey)) {
      toReturn = _preferences!.getInt(constants.daysToExpirationWarningKey) ??
          toReturn;
    }

    return toReturn;
  }

  int stopNotifyingExpirationAfterDays() {
    int toReturn = constants.stopNotifyingExpirationAfterDays;

    if (_preferences!
        .containsKey(constants.stopNotifyingExpirationAfterDaysKey)) {
      toReturn =
          _preferences!.getInt(constants.stopNotifyingExpirationAfterDaysKey) ??
              toReturn;
    }

    return toReturn;
  }

  String csvFieldSeparator() {
    return _preferences!.getString(constants.csvFieldSeparatorKey) ??
        constants.csvFieldSeparator;
  }

  String csvStringFieldIdentifier() {
    return _preferences!.getString(constants.csvStringFieldIdentifierKey) ??
        constants.csvStringFieldIdentifier;
  }
}
