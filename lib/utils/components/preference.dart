import 'package:autowheel_workshop/utils/components/library.dart';

class Preference {
  static late SharedPreferences preferences;

  static bool getBool(String key) {
    return preferences.getBool(key) ?? false;
  }

  static String getString(String key) {
    return preferences.getString(key) ?? "";
  }

  static int getint(String key) {
    return preferences.getInt(key) ?? 0;
  }

  static Future<bool> setBool(String key, bool value) async {
    return await preferences.setBool(key, value);
  }

  static Future<bool> setString(String key, String value) async {
    return await preferences.setString(key, value);
  }

  static Future<bool> setInt(String key, int value) async {
    return await preferences.setInt(key, value);
  }
}

class PrefKeys {
  static const userstatus = "userstatus";
  static const locationId = "locationId";
  static const phoneNumber = "phoneNumber";
  static const email = "email";
  static const staffId = "staffId";
  static const userType = "userType";
  static const financialYear = "financialYear";
}

logoutPrefData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(PrefKeys.userstatus);
  await prefs.remove(PrefKeys.locationId);
  await prefs.remove(PrefKeys.phoneNumber);
  await prefs.remove(PrefKeys.email);
  await prefs.remove(PrefKeys.staffId);
  await prefs.remove(PrefKeys.userType);
  await prefs.remove(PrefKeys.financialYear);
}
