import 'package:shared_preferences/shared_preferences.dart';

class Cache {
  static late SharedPreferences sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static dynamic getData({required key}) {
    return sharedPreferences.get(key);
  }

  static Future<bool> setData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await sharedPreferences.setString(key, value);
    if (value is int) return await sharedPreferences.setInt(key, value);
    if (value is bool) return await sharedPreferences.setBool(key, value);

    return await sharedPreferences.setDouble(key, value);
  }

  static Future<bool> removeData(key) async {
    return await sharedPreferences.remove(key);
  }

  static Future<bool> setStrings(key, List<String> value) async {
    return await sharedPreferences.setStringList(key, value);
  }

  static List<String>? getStrings(key) {
    return sharedPreferences.getStringList(key);
  }
}
